import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kpigi_chat_app/app/screens/login_screen.dart';
import 'package:kpigi_chat_app/services/notification_service.dart';

Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Background notification
  FirebaseMessaging.onBackgroundMessage(
    firebaseBackgroundHandler,
  );

  // 🔔 INIT NOTIFICATION SERVICE (ONCE)
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KPIGI Chat App',
      home: LoginScreen(),
    );
  }
}
