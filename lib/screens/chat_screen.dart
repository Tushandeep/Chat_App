import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lets Chat'),
        actions: [
          PopupMenuButton(
            onSelected: (val) {
              if (val == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            itemBuilder: (_) {
              return <PopupMenuItem>[
                PopupMenuItem(
                  value: 'logout',
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app_outlined,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 6),
                        const Text('Logout'),
                      ],
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Builder(builder: (context) {
        final user = FirebaseAuth.instance.currentUser;
        return SizedBox(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Messages(currentUser: user!),
              ),
              const NewMessage(),
            ],
          ),
        );
      }),
    );
  }
}
