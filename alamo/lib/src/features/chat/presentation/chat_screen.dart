import 'package:alamo/src/features/chat/presentation/chat_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/features/chat/domain/app_thread.dart';
import 'package:alamo/src/widgets/message_bubble.dart';

class ChatScreen extends ConsumerWidget {
  final String userId;

  const ChatScreen({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = ref.watch(chatScreenControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
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
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text("No messages yet."));
                    }

                    final thread = snapshot.data!;
                    return ListView.builder(
                      reverse: true,
                      itemCount: thread.messages.length,
                      itemBuilder: (context, index) {
                        final message = thread.messages[index];
                        final userIsSender = message.senderId == userId;

                        return MessageBubble(
                          senderName: message.senderId,
                          text: message.content,
                          date: message.timestamp.toLocal().toString(),
                          userIsSender: userIsSender,
                        );
                      },
                    );
                  },
                ),
              ),
              _buildMessageInput(context, chatController, threadId),
            ],
          );
        },
      ),
    );
  }

  // Message input field for sending messages
  Widget _buildMessageInput(BuildContext context, ChatScreenController chatController, String threadId) {
    final TextEditingController messageController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Enter message',
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  chatController.sendMessage(threadId, userId, text);
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
                chatController.sendMessage(threadId, userId, text);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
