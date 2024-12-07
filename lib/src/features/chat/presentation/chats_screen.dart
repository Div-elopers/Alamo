import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/features/chat/domain/app_chat.dart';
import 'package:alamo/src/widgets/message_bubble.dart';
import 'package:alamo/src/features/chat/presentation/chat_screen_controller.dart';
import 'package:alamo/src/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(
        title: const Text('Chats'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: FutureBuilder<List<Chat>>(
        future: chatController.getChats(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return Dismissible(
                  key: ValueKey(chat.chatId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red[800],
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    final chatController = ref.read(chatScreenControllerProvider.notifier);
                    await chatController.deleteChat(chat.chatId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Chat eliminado',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                        duration: Durations.extralong3,
                      ),
                    );
                  },
                  child: ChatItem(
                    chat: chat,
                    onTap: () => context.pushNamed(
                      AppRoute.assistant.name,
                      pathParameters: {"chatId": chat.chatId, "userId": userId},
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No tienes chats.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newChatId = await chatController.createChat(userId);
          context.pushNamed(AppRoute.assistant.name, pathParameters: {"chatId": newChatId, "userId": userId});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatItem({
    required this.chat,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lastMessage = chat.messages.isNotEmpty ? chat.messages.first.content : "Sin mensajes aún";
    return ListTile(
      title: const Text("Chat con Alamo"),
      subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        "${chat.lastUpdated.hour}:${chat.lastUpdated.minute.toString().padLeft(2, '0')}",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }
}
