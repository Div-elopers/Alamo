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
  Future<void> addMessage(String threadId, String senderId, String messageContent) async {
    final messageData = {
      'senderId': senderId,
      'content': messageContent,
      'timestamp': DateTime.now(),
      'type': 'text',
    };

    // Add the message to Firestore
    await _chatRepository.addMessage(threadId, messageData);

    // Now trigger the cloud function to send the conversation to ChatGPT
    // await _sendMessageToChatGPT(threadId);
  }

  Future<void> _sendMessageToChatGPT(String threadId) async {
    // Fetch the full chat thread
    final thread = await _chatRepository.fetchChatThread(threadId);

    // Ensure the thread exists and has messages
    if (thread != null) {
      // Convert the thread to ChatGPT-compatible format
      final List<Map<String, String>> conversation = thread.toChatGPTFormat();

      // Call the Cloud Function to process the conversation with ChatGPT
      final HttpsCallable callable = _cloudFunctions.httpsCallable('chatGPTFunction');
      final response = await callable.call({
        'threadId': threadId,
        'messages': conversation,
      });

      // Handle the response from ChatGPT and store it as a new message
      if (response.data != null) {
        final botMessage = {
          "senderId": 'chatbot',
          "content": response.data['reply'],
          "timestamp": DateTime.now(),
          "type": 'text',
        };

        // Save the bot's reply as a new message in the thread
        await _chatRepository.addMessage(threadId, botMessage);
      }
    }
  }
}

@Riverpod(keepAlive: true)
ChatService chatService(ChatServiceRef ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  final cloudFunctions = FirebaseFunctions.instance;

  return ChatService(chatRepository, cloudFunctions);
}
