import 'package:alamo/src/features/auth/domain/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = _generateDummyUsers();
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: users.length + (selectedIndex != -1 ? 1 : 0),
                itemBuilder: (context, index) {
                  if (selectedIndex != -1 && index == selectedIndex + 1) {
                    // Return the edit section if this is the row right after the selected user
                    return _buildEditUserRow(context, users[selectedIndex]);
                  }

                  // Adjust the index for the DataTable to skip the edit row
                  final userIndex = selectedIndex != -1 && index > selectedIndex ? index - 1 : index;

                  final user = users[userIndex];

                  return UserRowWidget(
                    user: user,
                    onTap: () {
                      final currentIndex = ref.read(selectedIndexProvider);
                      ref.read(selectedIndexProvider.notifier).state = (currentIndex == userIndex)
                          ? -1 // Deselect if the same row is tapped
                          : userIndex;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditUserRow(BuildContext context, AppUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit User: ${user.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Department',
                  hintText: user.department ?? 'Enter department',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: user.phoneNumber ?? 'Enter phone number',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add update functionality
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Update'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add delete functionality
                      Navigator.pop(context);
                    },
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<AppUser> _generateDummyUsers() {
    return List.generate(6, (index) {
      return AppUser(
        uid: 'user_$index',
        email: 'user$index@email.com',
        name: 'User ${index + 1}',
        phoneNumber: '123-456-789$index',
        department: 'Department ${index % 2 == 0 ? 'A' : 'B'}',
        createdAt: DateTime.now(),
        profileUrl: '', // Add a default profile image URL if needed
      );
    });
  }
}

// Provider for selected index
final selectedIndexProvider = StateProvider<int>((ref) => -1);

class UserRowWidget extends StatelessWidget {
  final AppUser user;
  final VoidCallback onTap;

  const UserRowWidget({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.name),
              const Text('User'),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Add delete functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
