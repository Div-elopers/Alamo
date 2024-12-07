import 'dart:async';
import 'package:alamo/src/features/chat/domain/app_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  const ChatRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Firestore paths for chat collection
  static String chatsPath() => 'chats';
  static String chatPath(String chatId) => 'chats/$chatId';

  // Fetch a single chat chat by chatId
  Future<Chat?> fetchChat(String chatId) async {
    final ref = _chatRef(chatId);
    final snapshot = await ref.get();
    return _getChatFromDocumentSnapshot(snapshot);
  }

  // Watch a single chat chat by chatId as a stream
  Stream<Chat?> watchChat(String chatId) {
    final ref = _chatRef(chatId);
    return ref.snapshots().map((snapshot) => _getChatFromDocumentSnapshot(snapshot));
  }

  Future<void> addThreadId(String threadId, String chatId) async {
    try {
      await _firestore.collection(chatsPath()).doc(chatId).update({
        'threadId': threadId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chat>> findChatsByParticipant(String userId) async {
    final querySnapshot = await _firestore.collection(chatsPath()).where('participants', arrayContains: userId).get();

    return querySnapshot.docs.map((doc) {
      return Chat.fromDocument(doc.id, doc.data());
    }).toList();
  }

  Future<Chat> createChat(String userId) async {
    final docRef = _firestore.collection(chatsPath()).doc();
    final chatData = {
      'participants': [userId],
      'messages': [],
      'lastUpdated': FieldValue.serverTimestamp(),
      'threadId': ""
    };

    await docRef.set(chatData);

    return Chat.fromDocument(docRef.id, chatData);
  }

  Future<List<Chat>> findChats(String userId) async {
    final chats = await findChatsByParticipant(userId);

    if (chats.isNotEmpty) {
      return chats;
    } else {
      return [];
    }
  }

  // Add a message to the chat chat
  Future<void> addMessage(String chatId, Map<String, dynamic> messageData) async {
    final ref = _chatRef(chatId);

    await ref.update({
      'messages': FieldValue.arrayUnion([messageData]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Delete a chat chat
  Future<void> deleteChat(String chatId) {
    return _firestore.doc(chatPath(chatId)).delete();
  }

  // Helper methods to create Firestore references
  DocumentReference<Map<String, dynamic>> _chatRef(String chatId) => _firestore.doc(chatPath(chatId));

  Chat? _getChatFromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      return Chat.fromDocument(snapshot.id, snapshot.data()!);
    } else {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(FirebaseFirestore.instance);
}

// A provider for watching a specific chat chat by chatId
@riverpod
Stream<Chat?> chatStream(Ref ref, String chatId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.watchChat(chatId);
}

// A provider for fetching a specific chat chat by chatId
@riverpod
Future<Chat?> chatFuture(Ref ref, String chatId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.fetchChat(chatId);
}
