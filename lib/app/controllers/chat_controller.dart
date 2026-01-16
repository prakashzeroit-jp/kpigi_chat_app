
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpigi_chat_app/services/firebase_service.dart';

class ChatController extends GetxController {
  final messageC = TextEditingController();
  final FirebaseService _service = FirebaseService();
  final ScrollController scrollController = ScrollController();

  // 🔄 Messages stream
  Stream<QuerySnapshot> messageStream() {
    return _service.getMessages();
  }

  // 📩 Send Message
  void sendMessage(String receiverId) {
    if (messageC.text.trim().isEmpty) return;

    _service.sendMessage(
      messageC.text.trim(),
      receiverId,
    );

    messageC.clear();
  }

  // 👤 Current User ID
  String? get currentUserId => _service.currentUserId;
}


// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:kpigi_chat_app/services/firebase_service.dart';


// class ChatController extends GetxController {
//   final messageC = TextEditingController();
//   final FirebaseService _service = FirebaseService();
//   final ScrollController scrollController = ScrollController();
//   final ImagePicker _picker = ImagePicker();
  
// // 🔄 Get Messages Stream
//   Stream<QuerySnapshot> messageStream() {
//     return _service.getMessages();
//   }
// // 📩 Send Message
// Future<void> pickImage(String receiverId) async {
//   final XFile? image = await _picker.pickImage(
//     source: ImageSource.gallery,
//     imageQuality: 70,
//   );

//   if (image == null) return;

//   await _service.sendImage(
//     File(image.path),
//     receiverId,
//   );
// }
//   // void sendMessage() {
//   //   print("UID => ${_service.currentUserId}");
//   //   if (messageC.text.trim().isEmpty) return;
//   //   _service.sendMessage(messageC.text.trim());
//   //   messageC.clear();
//   // }

//   // 🖼️ Pick image from gallery & send
//   // Future<void> pickImage() async {
//   //   final XFile? image = await _picker.pickImage(
//   //     source: ImageSource.gallery,
//   //     imageQuality: 70,
//   //   );

//   //   if (image == null) return;

//   //   await _service.sendImage(File(image.path));
//   // }
//   // 👤 Current User ID
//   String? get currentUserId => _service.currentUserId;
// }
