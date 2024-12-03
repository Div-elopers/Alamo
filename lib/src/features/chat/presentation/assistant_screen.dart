import 'package:alamo/src/features/chat/domain/app_chat.dart';
import 'package:alamo/src/features/chat/presentation/chat_screen_controller.dart';
import 'package:alamo/src/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AssistantScreen extends ConsumerWidget {
  final String chatId;

  const AssistantScreen({required this.chatId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = ref.watch(chatScreenControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatMessages(context, chatId, chatController),
          ),
          _buildMessageInput(context, chatController, chatId),
        ],
      ),
    );
  }
}

Widget _buildChatMessages(BuildContext context, String chatId, ChatScreenController chatController) {
  return StreamBuilder<Chat?>(
    stream: chatController.watchChat(chatId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData && snapshot.data != null) {
        final chat = snapshot.data!;
        return ListView.builder(
          reverse: true,
          itemCount: chat.messages.length,
          itemBuilder: (context, index) {
            final message = chat.messages[index];
            return MessageBubble(
              senderName: message.userIsSender ? "Tú" : "Chatbot",
              text: message.content,
              date: message.formattedTime,
              userIsSender: message.userIsSender,
            );
          },
        );
      } else {
        return const Center(child: Text('No hay mensajes en este chat.'));
      }
    },
  );
}

Widget _buildMessageInput(BuildContext context, ChatScreenController chatController, String chatId) {
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
                chatController.sendMessage(chatId, text, "");
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
              chatController.sendMessage(chatId, text, "");
              messageController.clear();
            }
          },
        ),
      ],
    ),
  );
}
