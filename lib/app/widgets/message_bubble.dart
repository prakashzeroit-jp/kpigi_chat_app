

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String? message;
  final String? imageUrl;
  final bool isMe;
  final String type;

  const MessageBubble({
    super.key,
    this.message,
    this.imageUrl,
    required this.isMe,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: type == "image"
            ? Image.network(imageUrl!, width: 200)
            : Text(
                message!,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class MessageBubble extends StatelessWidget {
//   final String message;
//   final bool isMe;

//   const MessageBubble({super.key, required this.message, required this.isMe});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.indigo : Colors.grey.shade300,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(12),
//             topRight: const Radius.circular(12),
//             bottomLeft: isMe
//                 ? const Radius.circular(12)
//                 : const Radius.circular(0),
//             bottomRight: isMe
//                 ? const Radius.circular(0)
//                 : const Radius.circular(12),
//           ),
//         ),
//         child: Text(
//           message,
//           style: TextStyle(color: isMe ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }
// }
