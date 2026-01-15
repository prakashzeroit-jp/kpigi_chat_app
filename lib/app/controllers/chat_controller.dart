import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kpigi_chat_app/services/firebase_service.dart';

class ChatController extends GetxController {
  final messageC = TextEditingController();
  final FirebaseService _service = FirebaseService();

  Stream<QuerySnapshot> messageStream() {
    return _service.getMessages();
  }

  void sendMessage() {
    if (messageC.text.trim().isEmpty) return;
    _service.sendMessage(messageC.text.trim());
    messageC.clear();
  }

  String? get currentUserId => _service.currentUserId;
}
