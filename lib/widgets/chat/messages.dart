import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/message_bubble.dart';

class Messages extends StatelessWidget {
  final User currentUser;
  const Messages({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<dynamic>>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (_, chatSnap) {
        if (chatSnap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          reverse: true,
          itemCount: chatSnap.data!.docs.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: MessageBubble(
                message: chatSnap.data!.docs[index]['text'],
                isMe: chatSnap.data!.docs[index]['userId'] == currentUser.uid,
                messageKey: ValueKey(chatSnap.data!.docs[index].id),
                username: chatSnap.data!.docs[index]['username'],
                imageUrl: chatSnap.data!.docs[index]['userImage'],
              ),
            );
          },
        );
      },
    );
  }
}
