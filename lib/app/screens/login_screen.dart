import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:kpigi_chat_app/app/screens/chat_screen.dart';
import 'package:kpigi_chat_app/services/firebase_service.dart';

class LoginScreen extends StatelessWidget {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            TextField(
              controller: passC,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailC.text.trim(),
                      password: passC.text.trim(),
                    );

                    // 🔔 IMPORTANT: Save FCM token
                    await _firebaseService.saveFcmToken();

                    // 👉 Go to chat
                    Get.offAll(ChatScreen());
                  } catch (e) {
                    Get.snackbar(
                      "Login Error",
                      e.toString(),
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
