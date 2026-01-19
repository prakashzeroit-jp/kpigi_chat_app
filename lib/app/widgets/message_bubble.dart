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
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (type == "image" && imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: 200,
        fit: BoxFit.cover,
      );
    }

    // default = text
    return Text(
      message ?? "",
      style: TextStyle(
        color: isMe ? Colors.white : Colors.black,
        fontSize: 14,
      ),
    );
  }
}


