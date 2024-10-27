import 'dart:developer';

import 'package:alamo/src/features/chat/data/chat_repository.dart';
import 'package:alamo/src/features/chat/domain/app_chat.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_service.g.dart';

class ChatService {
  final ChatRepository _chatRepository;
  final FirebaseFunctions _cloudFunctions;

  ChatService(this._chatRepository, this._cloudFunctions);

  // Fetch a chat chat by its chatId
  Future<Chat?> fetchChat(String chatId) {
    return _chatRepository.fetchChat(chatId);
  }

  // Watch a chat chat as a stream (real-time updates)
  Stream<Chat?> watchChat(String chatId) {
    return _chatRepository.watchChat(chatId);
  }

  // Create or update a chat chat in Firestore
  Future<void> createChat(String userId) {
    return _chatRepository.createChat(userId);
  }

  // Add a message to the chat chat in Firestore
  Future<void> addMessage(String chatId, String messageContent, String threadId) async {
    final messageData = {
      'userIsSender': true,
      'content': messageContent,
      'timestamp': DateTime.now(),
      'type': 'text',
    };

    // Add the message to Firestore
    await _chatRepository.addMessage(chatId, messageData);

    // Now trigger the cloud function to send the conversation to ChatGPT
    await _sendMessageToAssistant(chatId, threadId, messageContent);
  }

  Future<void> _sendMessageToAssistant(String chatId, String threadId, String messageContent) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log("User is not authenticated");
        return;
      }

      bool firstMessage = threadId.isEmpty;

      final payload = {
        'openai_thread_id': threadId,
        'message_content': messageContent,
      };

      // Call the Firebase function
      final response = await _cloudFunctions.httpsCallable('send_message_to_assistant').call(payload);

      if (response.data != null) {
        String? newThreadId = response.data['openai_thread_id'];
        String assistantMessage = response.data['response'];

        // If this is the first message, update the chat with the new threadId
        if (firstMessage && newThreadId != null && newThreadId.isNotEmpty) {
          await _chatRepository.addThreadId(newThreadId, chatId);
          threadId = newThreadId;
        }

        final messageData = {
          'userIsSender': false,
          'content': assistantMessage,
          'timestamp': DateTime.now(),
          'type': 'text',
        };
        await _chatRepository.addMessage(chatId, messageData);
      } else {
        log('Unexpected response format from Firebase function: ${response.data}', name: '_sendMessageToAssistant');
      }
    } catch (error) {
      log('Error in sending message to assistant: $error', name: '_sendMessageToAssistant');
    }
  }
}

@Riverpod(keepAlive: true)
ChatService chatService(ChatServiceRef ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  final cloudFunctions = FirebaseFunctions.instance;

  return ChatService(chatRepository, cloudFunctions);
}
