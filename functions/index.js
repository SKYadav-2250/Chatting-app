const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * Cloud Function to send push notifications for new chat messages
 * Triggers when a new message is added to any conversation
 */
exports.sendChatNotification = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    try {
      // Get message data
      const messageData = snapshot.data();
      const chatId = context.params.chatId;
      
      // Skip if it's a self-message
      if (messageData.fromId === messageData.toId) {
        console.log('Skipping notification for self-message');
        return null;
      }
      
      // Get recipient user data to get their FCM token
      const recipientSnapshot = await admin.firestore()
        .collection('users')
        .doc(messageData.toId)
        .get();
      
      if (!recipientSnapshot.exists) {
        console.log('Recipient does not exist');
        return null;
      }
      
      const recipientData = recipientSnapshot.data();
      const recipientToken = recipientData.pushToken || recipientData.push_token;
      
      // If no token, can't send notification
      if (!recipientToken) {
        console.log('No FCM token available for user:', messageData.toId);
        return null;
      }
      
      // Get sender data for notification
      const senderSnapshot = await admin.firestore()
        .collection('users')
        .doc(messageData.fromId)
        .get();
      
      if (!senderSnapshot.exists) {
        console.log('Sender does not exist');
        return null;
      }
      
      const senderData = senderSnapshot.data();
      const senderName = senderData.name || 'Someone';
      
      // Create notification content based on message type
      let notificationTitle = senderName;
      let notificationBody = '';
      
      // Check message type and customize notification
      switch(messageData.type) {
        case 'text':
          notificationBody = messageData.msg;
          break;
        case 'image':
          notificationBody = '📷 Image';
          break;
        default:
          notificationBody = 'New message';
      }
      
      // Construct the message using the recommended approach
      const message = {
        notification: {
          title: notificationTitle,
          body: notificationBody
        },
        data: {
          chatId: chatId,
          messageId: context.params.messageId,
          senderId: messageData.fromId,
          type: messageData.type || 'text',
          clickAction: 'FLUTTER_NOTIFICATION_CLICK'
        },
        android: {
          notification: {
            sound: 'default',
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
          }
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              category: 'NEW_MESSAGE'
            }
          }
        },
        token: recipientToken
      };
      
      // Send the notification using the non-deprecated method
      console.log('Sending notification to:', recipientToken);
      const response = await admin.messaging().send(message);
      
      // Log success
      console.log('Notification sent successfully, message ID:', response);
      return { success: true, messageId: response };
      
    } catch (error) {
      console.error('Error sending notification:', error);
      return { error: error.message };
    }
  });

/**
 * Optional: Function to clean up old tokens
 * This helps maintain your FCM token database
 */
exports.cleanupInvalidTokens = functions.https.onRequest(async (req, res) => {
  try {
    // Get all users
    const usersSnapshot = await admin.firestore().collection('users').get();
    const cleanupPromises = [];
    
    usersSnapshot.forEach(userDoc => {
      const userData = userDoc.data();
      const token = userData.pushToken || userData.push_token;
      
      if (token) {
        // Test if token is still valid
        const testMessage = {
          data: { test: 'test' },
          token: token
        };
        
        const promise = admin.messaging().send(testMessage)
          .catch(error => {
            // If token is invalid, remove it
            if (error.code === 'messaging/invalid-registration-token' ||
                error.code === 'messaging/registration-token-not-registered') {
              console.log('Removing invalid token for user:', userDoc.id);
              return userDoc.ref.update({
                pushToken: admin.firestore.FieldValue.delete(),
                push_token: admin.firestore.FieldValue.delete()
              });
            }
            return null;
          });
        
        cleanupPromises.push(promise);
      }
    });
    
    await Promise.all(cleanupPromises);
    res.status(200).send({ success: true, message: 'Token cleanup completed' });
    
  } catch (error) {
    console.error('Error in cleanup:', error);
    res.status(500).send({ error: error.message });
  }
});