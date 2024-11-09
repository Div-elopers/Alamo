import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/features/chat/domain/app_chat.dart';
import 'package:alamo/src/widgets/message_bubble.dart';
import 'package:alamo/src/features/chat/presentation/chat_screen_controller.dart';
import 'package:alamo/src/widgets/custom_app_bar.dart';

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
        final senderName = user?.name ?? 'usuario';

        return Scaffold(
          appBar: const CustomAppBar(title: 'Asistente virtual'), // Usar CustomAppBar aquí
          body: FutureBuilder<String>(
            future: chatController.getOrCreateChatId(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final chatId = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: StreamBuilder<Chat?>(
                      stream: chatController.watchChat(chatId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.messages.isEmpty) {
                          // Si el chat no tiene mensajes, mostrar las categorías
                          return _buildCategorySelection(context, chatController, chatId);
                        }

                        final chat = snapshot.data!;
                        final threadId = chat.threadId;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                itemCount: chat.messages.length,
                                itemBuilder: (context, index) {
                                  final message = chat.messages[index];

                                  return MessageBubble(
                                    senderName: message.userIsSender ? senderName : 'Chatbot',
                                    text: message.content,
                                    date: message.formattedTime,
                                    userIsSender: message.userIsSender,
                                  );
                                },
                              ),
                            ),
                            _buildMessageInput(context, chatController, chatId, threadId),
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
  Widget _buildCategorySelection(BuildContext context, ChatScreenController chatController, String chatId) {
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
                    chatController.sendMessage(chatId, category, "");
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
  Widget _buildMessageInput(BuildContext context, ChatScreenController chatController, String chatId, String threadId) {
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
                  chatController.sendMessage(chatId, text, threadId);
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
                chatController.sendMessage(chatId, text, threadId);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
