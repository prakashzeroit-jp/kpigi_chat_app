import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 Login
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 🚪 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 📩 Send Message
  Future<void> sendMessage(String message) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection("messages").add({
      "text": message,
      "uid": user.uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // 🔄 Get Messages Stream
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection("messages")
        .orderBy("createdAt", descending: false)
        .snapshots();
  }

  // 👤 Current User ID
  String? get currentUserId => _auth.currentUser?.uid;
}
