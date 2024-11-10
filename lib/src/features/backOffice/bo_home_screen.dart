import 'package:alamo/src/features/backoffice/user_management_screen.dart';
import 'package:alamo/src/features/library/presentation/library_screen.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/widgets/responsive_scrollable_card.dart';
import 'package:alamo/src/widgets/custom_button.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:go_router/go_router.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class BackOfficeHomeScreen extends ConsumerWidget {
  const BackOfficeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 90.0),
          child: Text(
            'Back Office',
            style: TextStyle(
              color: Color(0xff1B1C41),
              fontSize: 20,
              fontFamily: 'Sofia Sans',
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildCard(
                  context,
                  'User Management',
                  'Manage application users',
                  'assets/images/user_management.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                    );
                  },
                ),
                _buildCard(
                  context,
                  'Library',
                  'Manage files and documents',
                  'assets/images/files_management.png',
                  () {
                    context.goNamed(AppRoute.library.name);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String description, String imagePath, VoidCallback onTap) {
    return ResponsiveScrollableCard(
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 190,
              width: double.infinity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: CustomButton(
                text: title,
                onPressed: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
