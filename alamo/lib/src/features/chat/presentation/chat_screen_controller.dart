import 'dart:async';
import 'package:alamo/src/features/chat/application/chat_service.dart';
import 'package:alamo/src/features/chat/data/chat_repository.dart';
import 'package:alamo/src/features/chat/domain/app_chat.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_screen_controller.g.dart';

@riverpod
class ChatScreenController extends _$ChatScreenController {
  String? chatId;

  @override
  FutureOr<void> build() {
    // Initialize the controller with no specific state
  }

  // Watch the chat in real-time
  Stream<Chat?> watchChat(String chatId) {
    final chatService = ref.read(chatServiceProvider);
    return chatService.watchChat(chatId);
  }

  // Fetch a chat by chatId (for initial loading or refresh)
  Future<Chat?> fetchChat(String chatId) async {
    final chatService = ref.read(chatServiceProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => chatService.fetchChat(chatId));

    state = result;

    return result.value;
  }

  // Send a message
  Future<void> sendMessage(String chatId, String messageContent, String threadId) async {
    final chatService = ref.read(chatServiceProvider);
    state = const AsyncLoading(); // Set the state to loading while message is being sent

    // Attempt to send the message and update the state accordingly
    state = await AsyncValue.guard(() => chatService.addMessage(chatId, messageContent, threadId));
  }

  Future<String> getOrCreateChatId(String userId) async {
    // Retrieve both chatId and threadId
    final chatData = await _generateOrFetchChatId(userId);
    return chatData;
  }

  Future<String> _generateOrFetchChatId(String userId) async {
    final chatRepository = ref.read(chatRepositoryProvider);

    final existingChatId = await chatRepository.findChatByParticipant(userId);

    if (existingChatId != null) {
      return existingChatId;
    } else {
      final newChatId = await chatRepository.createChat(userId);
      return newChatId;
    }
  }
}
