const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotification = functions.firestore
  .document("messages/{id}")
  .onCreate(async (snap) => {
    const data = snap.data();

    if (!data.receiverId) return;

    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(data.receiverId)
      .get();

    if (!userDoc.exists) return;

    const token = userDoc.data().fcmToken;
    if (!token) return;

    const payload = {
      notification: {
        title: "New Message",
        body: data.text || "You have a new message",
      },
    };

    return admin.messaging().sendToDevice(token, payload);
  });
