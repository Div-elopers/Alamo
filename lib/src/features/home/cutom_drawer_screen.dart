import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/features/home/terms_screen.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider(ref.watch(authRepositoryProvider).currentUser!.uid)).value;
    if (user == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Drawer(
        child: Container(
          width: double.minPositive,
          height: double.infinity,
          color: colorScheme.surface,
          child: Column(
            children: [
              Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        user.profileUrl != ""
                            ? user.profileUrl
                            : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontFamily: 'Sofia Sans',
                              fontWeight: FontWeight.w900,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Opciones de navegación
              _buildListTile(
                icon: Icons.person,
                title: 'Perfil',
                color: colorScheme.primary,
                onTap: () {
                  context.goNamed(AppRoute.account.name);
                },
              ),
              _buildListTile(
                icon: Icons.help,
                title: 'Términos y condiciones',
                color: colorScheme.primary,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsScreen(),
                      ));
                },
              ),
              _buildListTile(
                icon: Icons.info,
                title: 'Eliminar cuenta',
                color: colorScheme.error,
                onTap: () async {
                  final delete = await showAlertDialog(
                    context: context,
                    title: '¿Estás seguro?',
                    cancelActionText: 'Cancelar',
                    defaultActionText: 'Eliminar',
                  );
                  if (delete == true) {
                    ref.read(accountScreenControllerProvider.notifier).deleteAccount();
                  }
                },
              ),
              const Spacer(),

              _buildListTile(
                icon: Icons.logout,
                title: 'Cerrar sesión',
                color: colorScheme.primary,
                onTap: () async {
                  final logout = await showAlertDialog(
                    context: context,
                    title: '¿Estás seguro?',
                    cancelActionText: 'Cancelar',
                    defaultActionText: 'Cerrar sesión',
                  );
                  if (logout == true) {
                    ref.read(accountScreenControllerProvider.notifier).signOut();
                  }
                },
              ),
              gapH32
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: color, fontFamily: 'Sofia Sans', fontWeight: FontWeight.w400),
      ),
      onTap: onTap,
    );
  }
}
