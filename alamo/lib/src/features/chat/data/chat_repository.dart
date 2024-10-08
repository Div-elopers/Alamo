import 'dart:async';
import 'package:alamo/src/features/chat/domain/app_thread.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  const ChatRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Firestore paths for chat collection
  static String chatsPath() => 'chat';
  static String chatPath(String threadId) => 'chat/$threadId';

  // Fetch a single chat thread by threadId
  Future<Thread?> fetchChatThread(String threadId) async {
    final ref = _chatRef(threadId);
    final snapshot = await ref.get();
    return _getThreadFromDocumentSnapshot(snapshot);
  }

  // Watch a single chat thread by threadId as a stream
  Stream<Thread?> watchChatThread(String threadId) {
    final ref = _chatRef(threadId);
    return ref.snapshots().map((snapshot) => _getThreadFromDocumentSnapshot(snapshot));
  }

  Future<String> createChatThread(String userId) async {
    final docRef = _firestore.collection('chat').doc(); // Generate a new threadId
    final threadData = {
      'participants': [userId],
      'messages': [],
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    await docRef.set(threadData);
    return docRef.id;
  }

  Future<String?> findThreadByParticipant(String userId) async {
    final querySnapshot = await _firestore
        .collection('chat')
        .where('participants', arrayContains: userId)
        .limit(1) // Assuming one thread per user
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  // Add a message to the chat thread
  Future<void> addMessage(String threadId, Map<String, dynamic> messageData) async {
    final ref = _chatRef(threadId);

    await ref.update({
      'messages': FieldValue.arrayUnion([messageData]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Delete a chat thread
  Future<void> deleteChatThread(String threadId) {
    return _firestore.doc(chatPath(threadId)).delete();
  }

  // Helper methods to create Firestore references
  DocumentReference<Map<String, dynamic>> _chatRef(String threadId) => _firestore.doc(chatPath(threadId));

  Thread? _getThreadFromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      return Thread.fromDocument(snapshot.id, snapshot.data()!);
    } else {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(FirebaseFirestore.instance);
}

// A provider for watching a specific chat thread by threadId
@riverpod
Stream<Thread?> chatThreadStream(ChatThreadStreamRef ref, String threadId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.watchChatThread(threadId);
}

// A provider for fetching a specific chat thread by threadId
@riverpod
Future<Thread?> chatThreadFuture(ChatThreadFutureRef ref, String threadId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.fetchChatThread(threadId);
}
