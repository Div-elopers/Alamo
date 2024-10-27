import 'package:alamo/src/features/chat/domain/app_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final List<String> participants;
  final List<Message> messages;
  final DateTime lastUpdated;
  final String threadId;

  Chat({required this.chatId, required this.participants, required this.messages, required this.lastUpdated, required this.threadId});

  // Factory method to create a Thread from Firestore data
  factory Chat.fromDocument(String chatId, Map<String, dynamic> data) {
    List<Message> messages = (data['messages'] != null
        ? (data['messages'] as List<dynamic>).map((messageData) => Message.fromDocument(messageData as Map<String, dynamic>)).toList()
        : <Message>[]);

    messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return Chat(
        chatId: chatId,
        participants: List<String>.from(data['participants'] as List<dynamic>),
        messages: messages,
        lastUpdated: (data['lastUpdated'] != null ? (data['lastUpdated'] as Timestamp).toDate() : DateTime.now()),
        threadId: data['threadId'] ?? "");
  }

  // Method to convert Thread to Firestore compatible map
  Map<String, dynamic> toDocument() {
    return {
      'participants': participants,
      'messages': messages.map((message) => message.toDocument()).toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'threadId': threadId
    };
  }

  List<Map<String, String>> toChatGPTFormat() {
    return messages.map((message) => message.toChatGPTFormat()).toList();
  }
}
