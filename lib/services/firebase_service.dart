import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  // 📩 Send TEXT Message
  Future<void> sendMessage(String message) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection("messages").add({
      "type": "text",
      "text": message,
      "uid": user.uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // 🖼️ Send IMAGE Message
  Future<void> sendImage(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = _storage
        .ref()
        .child("chat_images")
        .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    await _firestore.collection("messages").add({
      "type": "image",
      "imageUrl": imageUrl,
      "uid": user.uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // 🔄 Get Messages Stream
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // 👤 Current User ID
  String? get currentUserId => _auth.currentUser?.uid;
}



// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // 🔐 Login
//   Future<void> login(String email, String password) async {
//     await _auth.signInWithEmailAndPassword(email: email, password: password);
//   }

//   // 🚪 Logout
//   Future<void> logout() async {
//     await _auth.signOut();
//   }

//   // 📩 Send Message
//   Future<void> sendMessage(String message) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     await _firestore.collection("messages").add({
//       "text": message,
//       "uid": user.uid,
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//   }

//   // 🖼️ Send IMAGE Message
//   Future<void> sendImage(File imageFile) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     final ref = _storage
//         .ref()
//         .child("chat_images")
//         .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

//     await ref.putFile(imageFile);
//     final imageUrl = await ref.getDownloadURL();

//     await _firestore.collection("messages").add({
//       "type": "image",
//       "imageUrl": imageUrl,
//       "uid": user.uid,
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//   }

//   // 🔄 Get Messages Stream
//   Stream<QuerySnapshot> getMessages() {
//     return _firestore
//         .collection("messages")
//         .orderBy("createdAt", descending: true)
//         .snapshots();
//   }

//   // 👤 Current User ID
//   String? get currentUserId => _auth.currentUser?.uid;
// }
