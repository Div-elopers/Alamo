import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message {
  final bool userIsSender;
  final String content;
  final DateTime timestamp;
  final String type;
  final String formattedTime;

  Message({
    required this.userIsSender,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.formattedTime,
  });

  // Factory method to create a Message from Firestore data
  factory Message.fromDocument(Map<String, dynamic> data) {
    final DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

    final String formattedTime = DateFormat('HH:mm').format(timestamp);
    return Message(
      userIsSender: data['userIsSender'] as bool,
      content: data['content'] as String,
      timestamp: timestamp,
      formattedTime: formattedTime,
      type: data['type'] as String,
    );
  }

  // Method to convert Message to Firestore compatible map
  Map<String, dynamic> toDocument() {
    return {
      'userIsSender': userIsSender,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type,
    };
  }

  Map<String, String> toChatGPTFormat() {
    return {
      'role': 'user',
      'content': content,
    };
  }
}
