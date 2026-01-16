import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔔 Init Notification Service
  Future<void> init() async {
    // 1️⃣ Request permission (Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2️⃣ Init local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings =
        InitializationSettings(android: androidSettings);

    await _local.initialize(initSettings);

    // 3️⃣ Get FCM token
    final token = await _fcm.getToken();
    print("🔥 FCM TOKEN => $token");

    // 4️⃣ Save token to Firestore
    final user = _auth.currentUser;
    if (user != null && token != null) {
      await _firestore.collection("users").doc(user.uid).set({
        "fcmToken": token,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // 5️⃣ Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  /// 📢 Show local notification
  void _showNotification(RemoteMessage message) {
    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      channelDescription: 'Notifications for chat messages',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails =
        NotificationDetails(android: androidDetails);

    _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  /// 🔑 Get token (optional use)
  Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}


// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _local =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     // Permission
//     await _fcm.requestPermission();

//     // Init local notification
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const settings = InitializationSettings(android: android);
//     await _local.initialize(settings);

//     // Foreground message
//     FirebaseMessaging.onMessage.listen((message) {
//       _showNotification(message);
//     });
//   }

//   void _showNotification(RemoteMessage message) {
//     const androidDetails = AndroidNotificationDetails(
//       'chat_channel',
//       'Chat Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const notificationDetails =
//         NotificationDetails(android: androidDetails);

//     _local.show(
//       0,
//       message.notification?.title ?? 'New Message',
//       message.notification?.body ?? '',
//       notificationDetails,
//     );
//   }

//   Future<String?> getToken() async {
//     return await _fcm.getToken();
//   }
// }
