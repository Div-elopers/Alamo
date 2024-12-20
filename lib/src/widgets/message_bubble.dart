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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: userIsSender ? const Radius.circular(0) : const Radius.circular(25),
                topLeft: userIsSender ? const Radius.circular(25) : const Radius.circular(0),
                bottomLeft: const Radius.circular(25),
                bottomRight: const Radius.circular(25),
              ),
              border: Border.all(
                color: const Color.fromRGBO(27, 27, 64, 1.0),
                width: 0.5,
              ),
            ),
            child: Material(
              borderRadius: BorderRadius.only(
                topRight: userIsSender ? const Radius.circular(0) : const Radius.circular(25),
                topLeft: userIsSender ? const Radius.circular(25) : const Radius.circular(0),
                bottomLeft: const Radius.circular(25),
                bottomRight: const Radius.circular(25),
              ),
              color: userIsSender ? const Color.fromRGBO(27, 27, 64, 1.0) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      text,
                      style: _messageTextStyle(userIsSender),
                    ),
                    Text(
                      date,
                      style: _dateTextStyle(userIsSender),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

TextStyle _messageTextStyle(bool userIsSender) {
  return TextStyle(
    color: userIsSender ? Colors.white : const Color.fromRGBO(27, 27, 64, 1.0),
    fontSize: 14.0,
  );
}

TextStyle _dateTextStyle(bool userIsSender) {
  return TextStyle(
    color: userIsSender ? Colors.white : const Color.fromRGBO(27, 27, 64, 1.0),
    fontSize: 10.0,
  );
}
