import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String senderName, text, date;
  final bool userIsSender;

  const MessageBubble({
    super.key,
    required this.senderName,
    required this.text,
    required this.userIsSender,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: userIsSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            senderName,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topRight: userIsSender ? const Radius.circular(0) : const Radius.circular(30),
              topLeft: userIsSender ? const Radius.circular(30) : const Radius.circular(0),
              bottomLeft: const Radius.circular(30),
              bottomRight: const Radius.circular(30),
            ),
            elevation: 7,
            color: userIsSender ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
