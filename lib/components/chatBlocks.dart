import 'package:flutter/material.dart';

class ChatBlocks extends StatelessWidget {
  final String message;
  const ChatBlocks({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.green,
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16,
        color: Colors.white),
      ),
    );
  }
}
