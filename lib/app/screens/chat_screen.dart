import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpigi_chat_app/app/controllers/chat_controller.dart';
import 'package:kpigi_chat_app/app/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.put(ChatController());

  // TODO: isko dynamic banana (selected user se)
  final String receiverId = "OTHER_USER_UID";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          "Chat Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: controller.messageStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    return MessageBubble(
                      type: data["type"] ?? "text",
                      message: data["text"],
                      imageUrl: data["imageUrl"],
                      isMe:
                          data["senderId"] ==
                          controller.currentUserId,
                    );
                  },
                );
              },
            ),
          ),

          // input
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageC,
                    decoration: const InputDecoration(
                      hintText: "Type message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
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
