import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth/AuthService.dart';
import 'chatPage.dart';

class HomePage extends StatefulWidget {
  final void Function()? ontap;

  const HomePage({super.key, this.ontap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

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
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _userList()),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search users by email',
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          ),
          onChanged: (value) {
            setState(() {
              // Trigger rebuild to update the user list based on search query
            });
          },
        ),
      ),
    );
  }

  Widget _userListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
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
    } else {
      return Container();
    }
  }

  Widget _userList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> filteredUsers = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String userEmail = data['email'];
          return userEmail
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
        }).toList();

        return ListView(
          children:
              filteredUsers.map<Widget>((doc) => _userListItem(doc)).toList(),
        );
      },
    );
  }
}
