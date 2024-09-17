const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

TODO: 'fix this '
// Use your Gmail credentials with an App Password (generated in your Google account)
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "kzjstudiosinc@gmail.com",
    pass: "nzci doti gacq yjwc",  // Use the app password generated from Gmail
  },
});

exports.sendContactUsEmail = functions.firestore
  .document("contactUs/{contactId}")
  .onCreate((snap, context) => {
    const contactData = snap.data();

    // Compose the email
    const mailOptions = {
      from: "kzjstudiosinc@gmail.com",  // Sender email (your admin email)
      to: "kzjstudiosinc@gmail.com",  // Admin's email (could be the same or different)
      subject: `New Contact Us Message from ${contactData.name}`,
      text: `You have received a new message from ${contactData.name}:

            Name: ${contactData.name}
            Email: ${contactData.email}
            Message: ${contactData.message}
            
            Please reply to: ${contactData.email}`,
    };

    // Send the email
    return transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error("Error sending email:", error);
        return;
      }
      console.log("Email sent successfully:", info.response);
    });
  });

exports.sendNotificationOnMessage = functions.firestore
  .document("Chats/{chatId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    try {
      const messageData = snap.data();
      const receiverId = messageData.receiverId;

      console.log("Message data:", messageData);

      // Get the receiver's device token
      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(receiverId)
        .get();
      const userData = userDoc.data();
      const deviceToken = userData.deviceToken;

      console.log("Device token:", deviceToken);

      if (deviceToken) {
        const payload = {
          notification: {
            title: "New Message",
            body: messageData.message,
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
          data: {
            chatId: context.params.chatId,
          },
        };

        // Send notification
        await admin.messaging.sendToDevice(deviceToken, payload);
        console.log("Notification sent successfully");
      }
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });
