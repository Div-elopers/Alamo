import 'package:flutter/material.dart';
import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/utils/async_value_ui.dart';
import 'package:alamo/src/widgets/action_text_button.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:alamo/src/widgets/responsive_center.dart';
import 'package:alamo/src/widgets/verified.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Asegúrate de importar el archivo correcto

//import 'package:hooks_riverpod/hooks_riverpod.dart'; // Asegúrate de que este import esté presente

class CustomDrawer extends StatelessWidget {
  final WidgetRef ref; // Agrega el ref aquí

  const CustomDrawer({super.key, required this.ref}); // Modifica el constructor

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 390, // Ancho del Drawer
        height: double.infinity, // Altura completa
        color: Colors.white, // Color de fondo
        child: Column(
          children: [
            // Encabezado del Drawer
            Container(
              color: Colors.white, // Color del encabezado
              padding: const EdgeInsets.all(16.0), // Espacio interno
              child: Row(
                children: [
                  // Contenedor cuadrado
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/perfil.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Nombre del Usuario',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Sofia Sans',
                          fontWeight: FontWeight.w900),
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
              color: const Color(0xff1B1C41),
              onTap: () {
                // Lógica para ir a la pantalla de perfil
              },
            ),
            _buildListTile(
              icon: Icons.help,
              title: 'Términos y condiciones',
              color: const Color(0xff1B1C41),
              onTap: () {
                // Lógica
              },
            ),
            _buildListTile(
              icon: Icons.info,
              title: 'Eliminar cuenta',
              color: Colors.red,
              onTap: () async {
                final delete = await showAlertDialog(
                  context: context,
                  title: 'Estás seguro?',
                  cancelActionText: 'Cancelar',
                  defaultActionText: 'Eliminar',
                );
                if (delete == true) {
                  ref
                      .read(accountScreenControllerProvider.notifier)
                      .deleteAccount();
                }
              },
            ),
            const Spacer(),
            // Cerrar sesión
            _buildListTile(
              icon: Icons.logout,
              title: 'Cerrar sesión',
              color: const Color(0xff1B1C41),
              onTap: () async {
                final logout = await showAlertDialog(
                  context: context,
                  title: 'Estás seguro?',
                  cancelActionText: 'Cancelar',
                  defaultActionText: 'Cerrar sesión',
                );
                if (logout == true) {
                  ref.read(accountScreenControllerProvider.notifier).signOut();
                }
              },
            ),
          ],
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
        color: color, // Cambia el color del ícono aquí
        size: 30, // Cambia el tamaño del ícono aquí
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            color: color,
            fontFamily: 'Sofia Sans',
            fontWeight: FontWeight.w400),
      ),
      onTap: onTap,
    );
  }
}
