import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/buttons.dart';
import '../components/textFields.dart';
import '../services/auth/AuthService.dart';
import 'chatPage.dart';

class HomePage extends StatefulWidget{
  final void Function()? ontap;
  const HomePage({super.key, this.ontap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout))
        ],
      ),

      body: _userList(),
    );
  }

  Widget _userList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text('error');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('loading..');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _userListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _userListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String,dynamic>;

    if (_auth.currentUser!.email != data['email']){
      return ListTile(
        title: Text(data['email']),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ChatPage(
            receiverUserEmail: data['email'],
              receiverUserId: data['uid'],
            ),
            ),
          );
        },
      );
    }
    else{
      return Container();
    }
  }

}