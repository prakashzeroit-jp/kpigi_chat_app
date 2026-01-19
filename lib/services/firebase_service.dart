import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND MESSAGE
  Future<void> sendMessage(String message, String receiverId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection("messages").add({
      "type": "text",
      "text": message,
      "senderId": user.uid,
      "receiverId": receiverId,
      "senderName": user.email ?? "",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // SAVE FCM TOKEN (LOGIN TIME)
  Future<void> saveFcmToken() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    await _firestore.collection("users").doc(user.uid).set({
      "fcmToken": token,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // MESSAGE STREAM
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  String? get currentUserId => _auth.currentUser?.uid;
}
