import 'dart:async';
import 'package:alamo/src/features/chat/application/chat_service.dart';
import 'package:alamo/src/features/chat/data/chat_repository.dart';
import 'package:alamo/src/features/chat/domain/app_thread.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_screen_controller.g.dart';

@riverpod
class ChatScreenController extends _$ChatScreenController {
  String? threadId;

  @override
  FutureOr<void> build() {
    // Initialize the controller with no specific state
  }

  // Watch the chat thread in real-time
  Stream<Thread?> watchChatThread(String threadId) {
    final chatService = ref.read(chatServiceProvider);
    return chatService.watchChatThread(threadId);
  }

  // Fetch a chat thread by threadId (for initial loading or refresh)
  Future<Thread?> fetchChatThread(String threadId) async {
    final chatService = ref.read(chatServiceProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => chatService.fetchChatThread(threadId));

    state = result;

    return result.value;
  }

  // Send a message
  Future<void> sendMessage(String threadId, String messageContent) async {
    final chatService = ref.read(chatServiceProvider);
    state = const AsyncLoading(); // Set the state to loading while message is being sent

    // Attempt to send the message and update the state accordingly
    state = await AsyncValue.guard(() => chatService.addMessage(threadId, messageContent));
  }

  Future<String> getOrCreateThreadId(String userId) async {
    threadId ??= await _generateOrFetchThreadId(userId);
    return threadId!;
  }

  Future<String> _generateOrFetchThreadId(String userId) async {
    final chatRepository = ref.read(chatRepositoryProvider);

    final existingThreadId = await chatRepository.findThreadByParticipant(userId);

    if (existingThreadId != null) {
      return existingThreadId;
    } else {
      final newThreadId = await chatRepository.createChatThread(userId);
      return newThreadId;
    }
  }

  // You can add additional functions as needed for advanced features
}
