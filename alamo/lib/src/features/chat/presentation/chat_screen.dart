import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/features/chat/domain/app_thread.dart';
import 'package:alamo/src/widgets/message_bubble.dart';
import 'package:alamo/src/features/chat/presentation/chat_screen_controller.dart';

class ChatScreen extends ConsumerWidget {
  final String userId;

  const ChatScreen({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = ref.watch(chatScreenControllerProvider.notifier);
    final userStream = ref.watch(userStreamProvider(userId));

    return userStream.when(
      data: (user) {
        final senderName = user?.displayName ?? 'usuario';

        return Scaffold(
          appBar: AppBar(title: const Text('Asistente virtual')),
          body: FutureBuilder<String>(
            future: chatController.getOrCreateThreadId(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final threadId = snapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: StreamBuilder<Thread?>(
                      stream: chatController.watchChatThread(threadId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.messages.isEmpty) {
                          // Si el thread no tiene mensajes, mostrar las categorías
                          return _buildCategorySelection(context, chatController, threadId);
                        }

                        final thread = snapshot.data!;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                itemCount: thread.messages.length,
                                itemBuilder: (context, index) {
                                  final message = thread.messages[index];

                                  return MessageBubble(
                                    senderName: message.userIsSender ? senderName : 'Chatbot',
                                    text: message.content,
                                    date: message.formattedTime,
                                    userIsSender: message.userIsSender,
                                  );
                                },
                              ),
                            ),
                            _buildMessageInput(context, chatController, threadId),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => const Text('Error loading user info'),
    );
  }

  // Widget que muestra las categorías seleccionables
  Widget _buildCategorySelection(BuildContext context, ChatScreenController chatController, String threadId) {
    final categories = ['Alimentación', 'Salud', 'Vestimenta', 'Refugios', 'General'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Selecciona una categoría para comenzar:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: categories.map((category) {
              return ChoiceChip(
                label: Text(category),
                selected: false,
                onSelected: (selected) {
                  if (selected) {
                    chatController.sendMessage(threadId, category);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Input para mensajes
  Widget _buildMessageInput(BuildContext context, ChatScreenController chatController, String threadId) {
    final TextEditingController messageController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Escriba su mensaje',
                labelStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  chatController.sendMessage(threadId, text);
                  messageController.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = messageController.text;
              if (text.isNotEmpty) {
                chatController.sendMessage(threadId, text);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
