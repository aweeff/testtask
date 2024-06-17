import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testtask/components/chatBlocks.dart';
import 'package:testtask/components/textFields.dart';
import 'package:testtask/services/chatting/chatService.dart';

class ChatPage extends StatefulWidget{
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async{
    if (_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail),),
      body: Column(
        children: [
          Expanded(
              child: _messageList(),
          ),
          _messageInput(),
        ],
      ),
    );
  }

  Widget _messageList(){
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserId,
            _firebaseAuth.currentUser!.uid
        ),

        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Text('Loading..');
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _messageItem(document))
                .toList(),

          );

        }
    );
  }

  Widget _messageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
       padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          ChatBlocks(message: data['message']),
        ],
      ),
      ),
    );
  }

  Widget _messageInput(){
    return Row(
      children: [
        Expanded(
            child: TextFields(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
        ),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
                Icons.arrow_upward, size: 40)
        ),

      ],
    );
  }

}