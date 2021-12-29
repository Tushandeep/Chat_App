import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  var _enterMessage = '';

  UnderlineInputBorder get _decorateBorder {
    return UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(50),
    );
  }

  InputDecoration _decorateTextField(String title) {
    return InputDecoration(
      hintText: title,
      enabledBorder: _decorateBorder,
      focusedBorder: _decorateBorder,
    );
  }

  void _sendMessage() async {
    if (_enterMessage.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      FirebaseFirestore.instance.collection('chat').add(
        {
          'text': _enterMessage.trim(),
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'username': userData['username'],
          'userImage': userData['userImageUrl'],
        },
      );
      _enterMessage = '';
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 50,
                maxHeight: 150,
                minWidth: double.infinity,
                maxWidth: double.infinity,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                ),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Scrollbar(
                  child: TextField(
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    controller: _messageController,
                    decoration: _decorateTextField('Message'),
                    onChanged: (val) {
                      setState(() {
                        _enterMessage = val;
                      });
                    },
                    textInputAction: TextInputAction.newline,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 3.0,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: (_enterMessage.trim().isEmpty)
                  ? () {
                      setState(() {
                        _enterMessage = '';
                        _messageController.clear();
                      });
                    }
                  : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
