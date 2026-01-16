import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpigi_chat_app/app/controllers/chat_controller.dart';
import 'package:kpigi_chat_app/app/widgets/message_bubble.dart';
import 'package:kpigi_chat_app/services/notification_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.put(ChatController());
  final NotificationService _notificationService = NotificationService();

  // 🔴 TEMP: Receiver UID (CHANGE THIS)
  final String receiverId = "OTHER_USER_UID";

  @override
  void initState() {
    super.initState();
    _notificationService.init(); // foreground notification
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text("Chat Screen", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // 🔹 Messages
          Expanded(
            child: StreamBuilder(
              stream: controller.messageStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data =
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                    return MessageBubble(
                      type: data["type"] ?? "text",
                      message: data["text"],
                      imageUrl: data["imageUrl"],
                      isMe: data["senderId"] == controller.currentUserId,
                    );
                  },
                );
              },
            ),
          ),

          // 🔹 Input
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageC,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.sendMessage(receiverId);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kpigi_chat_app/app/controllers/chat_controller.dart';
// import 'package:kpigi_chat_app/app/widgets/message_bubble.dart';
// import 'package:kpigi_chat_app/services/notification_service.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final ChatController controller = Get.put(ChatController());
//   final NotificationService _notificationService = NotificationService();

//   @override
//   void initState() {
//     super.initState();
//     _notificationService.init(); // ✅ NOW VALID
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigoAccent,
//         title: const Text(
//           "Chat Screen",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: controller.messageStream(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 return ListView.builder(
//                   controller: controller.scrollController,
//                   reverse: true,
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final doc = snapshot.data!.docs[index];
//                     final data = doc.data() as Map<String, dynamic>;
//                     final type = data["type"] ?? "text";

//                     return MessageBubble(
//                       type: type,
//                       message: type == "text" ? data["text"] : null,
//                       imageUrl: type == "image" ? data["imageUrl"] : null,
//                       isMe: data["uid"] == controller.currentUserId,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller.messageC,
//                     decoration: const InputDecoration(
//                       hintText: "Type a message",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: controller.sendMessage,
//                 ),
//                 // IconButton(
//                 //   icon: const Icon(Icons.image),
//                 //   onPressed: controller.pickImage,
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:kpigi_chat_app/app/controllers/chat_controller.dart';
// import 'package:kpigi_chat_app/app/widgets/message_bubble.dart';

// class ChatScreen extends StatelessWidget {
//   ChatScreen({super.key});

//   final ChatController controller = Get.put(ChatController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigoAccent,
//         title: const Text(
//           "Chat Screen",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: controller.messageStream(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 return ListView(
//                   reverse: true,
//                   controller: controller.scrollController,
//                   children: snapshot.data!.docs.map((doc) {
//                     return MessageBubble(
//                       type: doc["type"],
//                       message: doc["type"] == "text" ? doc["text"] : null,
//                       imageUrl: doc["type"] == "image" ? doc["imageUrl"] : null,
//                       isMe: doc["uid"] == controller.currentUserId,
//                       // message: doc["text"],
//                       // isMe: doc["uid"] == controller.currentUserId,
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),

//           // Input box
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller.messageC,
//                     decoration: const InputDecoration(
//                       hintText: "Type a message",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: controller.sendMessage,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.image),
//                   onPressed: controller.pickImage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kpigi_chat_app/app/controllers/chat_controller.dart';
// import 'package:kpigi_chat_app/app/widgets/message_bubble.dart';
// import 'package:kpigi_chat_app/services/notification_service.dart';

// class ChatScreen extends StatelessWidget {
//   ChatScreen({super.key});

//   final ChatController controller = Get.put(ChatController());


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigoAccent,
//         title: const Text(
//           "Chat Screen",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: controller.messageStream(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 return ListView.builder(
//                   controller: controller.scrollController,
//                   reverse: true,
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final doc = snapshot.data!.docs[index];
//                     final data = doc.data() as Map<String, dynamic>;

//                     final type = data["type"] ?? "text";

//                     return MessageBubble(
//                       type: type,
//                       message: type == "text" ? data["text"] : null,
//                       imageUrl: type == "image" ? data["imageUrl"] : null,
//                       isMe: data["uid"] == controller.currentUserId,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // Input box
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller.messageC,
//                     decoration: const InputDecoration(
//                       hintText: "Type a message",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: controller.sendMessage,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.image),
//                   onPressed: controller.pickImage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
