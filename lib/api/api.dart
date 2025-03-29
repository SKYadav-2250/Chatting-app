import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'package:chatting_app/api/api_notification.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/models/message.dart' as chat_app_message;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Apis {
  static ChatUser? mySelf;

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static User? get user => auth.currentUser;

  static Future<bool> userExists() async {
    if (user == null) return false;
    return (await firestore.collection('users').doc(user!.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    if (user == null) throw Exception('No authenticated user');
    await firestore.collection('users').doc(user!.uid).get().then((doc) async {
      if (doc.exists) {
        mySelf = ChatUser.fromJson(doc.data()!);
        await setUpPushNotification();
        await updateOnlineStatus(true);
        developer.log('My Data: ${doc.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    if (user == null) throw Exception('No authenticated user');
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final newUser = ChatUser(
      image: user!.photoURL ?? 'https://default-image-url.com',
      about: 'Hey, I\'m using my app',
      name: user!.displayName ?? 'Anonymous',
      createdAt: time,
      isOnline: false,
      lastActive: time,
      id: user!.uid,
      email: user!.email ?? '',
      pushToken: '',
    );
    await firestore.collection('users').doc(user!.uid).set(newUser.toJson());
    developer.log('User created at: $time');
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user?.uid)
        .snapshots();
  }

  static Future<void> updateUserData() async {
    if (mySelf == null) throw Exception('User not initialized');
    await firestore.collection('users').doc(user?.uid).update({
      'name': mySelf!.name,
      'about': mySelf!.about,
    });
  }

  static Future<void> updateProfilePic(File file) async {
    if (user == null || mySelf == null) throw Exception('User not initialized');
    final ext = file.path.split('.').last;
    final ref = firebaseStorage.ref().child(
      'profile_picture/${user!.uid}.$ext',
    );
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    mySelf!.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user!.uid).update({
      'image': mySelf!.image,
      'about': mySelf!.about,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUser user,
  ) {
    return firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static String getConversationID(String id) {
    return user!.uid.hashCode <= id.hashCode
        ? '${user!.uid}_$id'
        : '${id}_${user!.uid}';
  }

  static Future<void> sendMessage(
    ChatUser chatuser,
    String msg,
    chat_app_message.MessageType type,
  ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final message = chat_app_message.Message(
      toId: chatuser.id.toString(),
      msg: msg,
      read: '',
      type: type,
      fromId: user!.uid,
      sent: time,
    );
    final ref= await firestore
        .collection(
          'chats/${getConversationID(chatuser.id.toString())}/messages',
        )
        .doc(time)
        .set(message.toJson()).then((value) =>
        ApiNotification.sendNotification(
          chatuser,message,msg,));
  }

  static Future<void> updateMessageReadStatus(
    chat_app_message.Message message,
  ) async {
    await firestore
        .collection('chats/${getConversationID(message.fromId)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
    ChatUser user,
  ) {
    return firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    final ref = firebaseStorage.ref().child(
      'images/${getConversationID(chatUser.id.toString())}/${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, chat_app_message.MessageType.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
    ChatUser chatUser,
  ) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateOnlineStatus(bool isOnline) async {
    if (mySelf == null) return;
    await firestore.collection('users').doc(user?.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': mySelf!.pushToken,
    });
  }

  static Future<void> setUpPushNotification() async {
    try {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await firebaseMessaging.getToken();
        if (token != null && mySelf != null) {
          mySelf!.pushToken = token;
          await updateOnlineStatus(true);
          developer.log('Push Token: $token');
        }
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        developer.log('Got a message whilst in the foreground!');
        developer.log('Message data: ${message.data}');

        if (message.notification != null) {
          developer.log(
            'Message also contained a notification: ${message.notification}',
          );
        }
      });
    } catch (e) {
      developer.log('Error setting up push notifications: $e');
    }
  }

  static void tokenUpdate() {
    firebaseMessaging.onTokenRefresh.listen((token) async {
      if (mySelf != null) {
        mySelf!.pushToken = token;
        await updateOnlineStatus(true);
        developer.log('Token refreshed: $token');
      }
    });
  }
}
