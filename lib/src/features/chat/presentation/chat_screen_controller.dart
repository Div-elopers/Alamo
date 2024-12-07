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
    state = const AsyncLoading();

    // Attempt to send the message and update the state accordingly
    state = await AsyncValue.guard(() => chatService.addMessage(chatId, messageContent, threadId));
  }

  Future<List<Chat>> getChats(String userId) async {
    final chatRepository = ref.read(chatRepositoryProvider);
    return await chatRepository.findChats(userId);
  }

  Future<String> createChat(String userId) async {
    final chatRepository = ref.read(chatRepositoryProvider);
    final chat = await chatRepository.createChat(userId);

    return chat.chatId;
  }

  Future<void> deleteChat(String chatId) async {
    final chatRepository = ref.read(chatRepositoryProvider);
    return chatRepository.deleteChat(chatId);
  }
}
