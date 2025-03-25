import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class Apis {
  static late ChatUser mySelf;

  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        mySelf = ChatUser.fromJson(user.data()!);
        print('my Data : ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final newUser = ChatUser(
      image: user.photoURL,
      about: 'hey i m using my app',
      name: user.displayName,
      createdAt: time,
      isOnline: false,
      lastActive: time,
      id: user.uid,
      email: user.email,
      pushToken: '',
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateuserData() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': mySelf.name,
      'about': mySelf.about,
    });
  }

  static Future<void> updateProfilePic(File file) async {
    final images = file.path.split('.').last;
    print('extention : $images');
    final ref = firebaseStorage.ref().child(
      'profile_picture/${user.uid}.$images',
    );
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$images'))
        .then((onValue) {
          print('Data Transfer : ${onValue.bytesTransferred / 1000} kb');
        });
    mySelf.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': mySelf.image,
      'about': mySelf.about,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUser user,
  ) {
    return firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages/').orderBy('sent',descending: true)
        .snapshots();
  }

  static String getConversationID(String id) {
    print('${user.uid.hashCode}----${id.hashCode}');
    return user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';
  }

  static Future<void> sendMessage(ChatUser chatuser, String msg,MessageType   type) async {
    try {
      print('chevlig error111');
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final Message message = Message(
        toId: chatuser.id.toString(),
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time,
      );
      print('checking lig error');
      final ref = firestore.collection(
        'chats/${getConversationID(chatuser.id.toString())}/messages',
      );
      print('checking  error');

      await ref.doc(time).set(message.toJson());
      print('checking  error');
    } catch (e) {
      print('error sending message : $e');
    }
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.fromId)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
    ChatUser user,
  ) {
    return  firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages')
        .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();
  }



  static Future<void> sendChatImage( ChatUser chatUser , File file)async{



      final images = file.path.split('.').last;
    print('extention : $images');
    final ref = firebaseStorage.ref().child(
      'images/${getConversationID(chatUser.id.toString())}/${DateTime.fromMillisecondsSinceEpoch}.$images',
    );
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$images'))
        .then((onValue) {
          print('Data Transfer : ${onValue.bytesTransferred / 1000} kb');
        });
    final imageUrl= await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, MessageType.image);

  }




}
