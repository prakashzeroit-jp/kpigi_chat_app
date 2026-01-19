
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


