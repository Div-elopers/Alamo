import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/features/backOffice/centers_management_screen.dart';
import 'package:alamo/src/features/backoffice/user_management_screen.dart';
import 'package:alamo/src/features/library/presentation/library_screen.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/widgets/responsive_scrollable_card.dart';
import 'package:alamo/src/widgets/custom_button.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:go_router/go_router.dart';

class BackOfficeHomeScreen extends ConsumerWidget {
  const BackOfficeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
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
        actions: [
          Center(
            child: IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                size: 50,
              ),
              onPressed: () async {
                final logout = await showAlertDialog(
                  context: context,
                  title: '¿Estás seguro?',
                  cancelActionText: 'Cancelar',
                  defaultActionText: 'Cerrar sesión',
                );
                if (logout == true) {
                  ref.read(accountScreenControllerProvider.notifier).signOut();
                  context.goNamed(AppRoute.signIn.name);
                }
              },
            ),
          ),
        ],
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
                    context.goNamed(AppRoute.userManagement.name);
                  },
                ),
                _buildCard(
                  context,
                  'Library',
                  'Manage files and documents',
                  'assets/images/files_management.png',
                  () {
                    showNotImplementedAlertDialog(context: context);
                  },
                ),
                _buildCard(
                  context,
                  'Centros de ayuda',
                  'Crea y administra centros de ayuda',
                  'assets/images/centers_image.png',
                  () {
                    context.goNamed(AppRoute.mapManagement.name);
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
