import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (context, futureSnapShot) {
          if (futureSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chat")
                  .orderBy(
                    "createdAt",
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (chatSnapshot.hasData) {
                  var chatDocs = chatSnapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (context, index) => MessageBubble(
                      chatDocs[index]["text"],
                      chatDocs[index]["userId"] == futureSnapShot.data!.uid,
                      chatDocs[index]["username"],
                      key:ValueKey(chatDocs[index],
                      ),
                    ),
                  );
                } else {
                  return Text("There is no data to display");
                }
              });
        });
  }
}
