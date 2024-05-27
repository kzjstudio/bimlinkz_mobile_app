const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnMessage = functions.firestore
    .document('Chats/{chatId}/messages/{messageId}')
    .onCreate(async (snap, context) => {
        try {
            const messageData = snap.data();
            const receiverId = messageData.receiverId;

            console.log('Message data:', messageData);

            // Get the receiver's device token
            const userDoc = await admin.firestore().collection('users').doc(receiverId).get();
            const userData = userDoc.data();
            const deviceToken = userData.deviceToken;

            console.log('Device token:', deviceToken);

            if (deviceToken) {
                const payload = {
                    notification: {
                        title: 'New Message',
                        body: messageData.message,
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    },
                    data: {
                        chatId: context.params.chatId,
                    },
                };

                // Send notification
                await admin.messaging().sendToDevice(deviceToken, payload);
                console.log('Notification sent successfully');
            }
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    });
