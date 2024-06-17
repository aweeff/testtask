import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{
   final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   Future<void> sendMessage(String receiverId, String message) async{

   }
}