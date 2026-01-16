const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotification = functions.firestore
  .document("messages/{messageId}")
  .onCreate(async (snap) => {
    try {
      const data = snap.data();
      const receiverId = data.receiverId;
      const text = data.text ?? "New message";

      if (!receiverId) {
        console.log("❌ receiverId missing");
        return null;
      }

      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(receiverId)
        .get();

      if (!userDoc.exists || !userDoc.data().fcmToken) {
        console.log("❌ No FCM token for receiver");
        return null;
      }

      await admin.messaging().send({
        token: userDoc.data().fcmToken,
        notification: {
          title: "New Message",
          body: text,
        },
        android: {
          priority: "high",
          notification: { channelId: "chat_channel" },
        },
      });

      console.log("✅ Push notification sent");
      return null;
    } catch (e) {
      console.error("🔥 Push error", e);
      return null;
    }
  });
