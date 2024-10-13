import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final _message;
  final _isMe;
  final Key key;
  final _userName;
  MessageBubble(this._message, this._isMe, this._userName, {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: _isMe
                ? Theme.of(context).canvasColor
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: !_isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight: _isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                _userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !_isMe ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                _message,
                style: TextStyle(
                  color: !_isMe ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
