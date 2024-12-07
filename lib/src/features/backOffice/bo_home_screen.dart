import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/features/backOffice/centers_management_screen.dart';
import 'package:alamo/src/features/backoffice/user_management_screen.dart';
import 'package:alamo/src/features/library/presentation/library_screen.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:alamo/src/widgets/custom_image.dart';
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
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Center(
            child: Row(
              children: [
                const Text("Cerrar sesión"),
                IconButton(
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
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          buildDecorativeImages(),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width / 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Back Office',
                    style: TextStyle(
                      color: Color(0xff1B1C41),
                      fontSize: 20,
                      fontFamily: 'Sofia Sans',
                    ),
                  ),
                ),
                _buildCard(
                  context,
                  'Administra aquí los usuarios de Alamo',
                  'assets/images/user_management.png',
                  () {
                    context.goNamed(AppRoute.userManagement.name);
                  },
                ),
                _buildCard(
                  context,
                  'Agrega archivos a la biblioteca',
                  'assets/images/files_management.png',
                  () {
                    context.goNamed(AppRoute.libraryManagement.name);
                  },
                ),
                _buildCard(
                  context,
                  'Crea centros de ayuda',
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

  Widget _buildCard(BuildContext context, String title, String imagePath, VoidCallback onTap) {
    return ResponsiveScrollableCard(
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shadowColor: Theme.of(context).colorScheme.primary,
        color: const Color.fromARGB(255, 221, 221, 236),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  height: MediaQuery.of(context).size.height / 5.5,
                  fit: BoxFit.fitHeight,
                ),
              ),
              // Text button inside the card
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: title,
                  onPressed: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
