import 'package:alamo/src/features/chat/data/chat_repository.dart';
import 'package:alamo/src/features/chat/domain/app_thread.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_service.g.dart';

class ChatService {
  final ChatRepository _chatRepository;
  final FirebaseFunctions _cloudFunctions;

  ChatService(this._chatRepository, this._cloudFunctions);

  // Fetch a chat thread by its threadId
  Future<Thread?> fetchChatThread(String threadId) {
    return _chatRepository.fetchChatThread(threadId);
  }

  // Watch a chat thread as a stream (real-time updates)
  Stream<Thread?> watchChatThread(String threadId) {
    return _chatRepository.watchChatThread(threadId);
  }

  // Create or update a chat thread in Firestore
  Future<void> createChatThread(String userId) {
    return _chatRepository.createChatThread(userId);
  }

  // Add a message to the chat thread in Firestore
  Future<void> addMessage(String threadId, String messageContent) async {
    final messageData = {
      'userIsSender': true,
      'content': messageContent,
      'timestamp': DateTime.now(),
      'type': 'text',
    };

    // Add the message to Firestore
    await _chatRepository.addMessage(threadId, messageData);

    // Now trigger the cloud function to send the conversation to ChatGPT
    //await _sendMessageToAssistant(threadId, messageContent);
  }

  Future<void> _sendMessageToAssistant(String threadId, String messageContent) async {
    try {
      // Prepare the data for the cloud function
      final HttpsCallable callable = _cloudFunctions.httpsCallable('send_message_to_assistant');

      // Call the cloud function with the threadId and the latest user message
      final response = await callable.call({
        'threadId': threadId,
        'messageContent': messageContent,
      });

      await _chatRepository.addMessage(threadId, response.data);
    } catch (error) {
      // Handle errors if something goes wrong
    }
  }
}

@Riverpod(keepAlive: true)
ChatService chatService(ChatServiceRef ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  final cloudFunctions = FirebaseFunctions.instance;

  return ChatService(chatRepository, cloudFunctions);
}
