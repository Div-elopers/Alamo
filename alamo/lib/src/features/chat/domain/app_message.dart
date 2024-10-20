import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String content;
  final DateTime timestamp;
  final String type;

  Message({
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  // Factory method to create a Message from Firestore data
  factory Message.fromDocument(Map<String, dynamic> data) {
    return Message(
      senderId: data['senderId'] as String,
      content: data['content'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: data['type'] as String,
    );
  }

  // Method to convert Message to Firestore compatible map
  Map<String, dynamic> toDocument() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type,
    };
  }

  Map<String, String> toChatGPTFormat() {
    return {
      'role': senderId == 'chatbot' ? 'assistant' : 'user',
      'content': content,
    };
  }
}