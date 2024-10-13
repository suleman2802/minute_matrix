import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _messageEntered = "";
  final _controller = TextEditingController();
  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection("/user")
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection("/chat").add({
      "text": _messageEntered,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username":userData["username"], 
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Send a message ...",
              ),
              onChanged: (value) {
                setState(() {
                  _messageEntered = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _messageEntered.trim().isEmpty ? null : sendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
