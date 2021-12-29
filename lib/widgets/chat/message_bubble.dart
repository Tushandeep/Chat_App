import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Key messageKey;
  final String message;
  final bool isMe;
  final String username;
  final String imageUrl;
  const MessageBubble({
    Key? key,
    required this.messageKey,
    required this.message,
    required this.isMe,
    required this.username,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Positioned(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    // width: message.length * 10 < 150 ? 150 :
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.deepPurple.withOpacity(0.6)
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: !isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                        bottomRight: isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                      ),
                    ),
                    width: message.length > 60
                        ? 280
                        : (message.length * 10 < 140)
                            ? 140
                            : null,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          textAlign: isMe ? TextAlign.right : TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -8,
              left: isMe ? -2 : null,
              right: isMe ? null : -2,
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    imageUrl,
                  ),
                ),
              ),
            ),
          ],
          clipBehavior: Clip.none,
        ),
      ],
    );
  }
}
