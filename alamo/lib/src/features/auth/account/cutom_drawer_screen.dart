import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 390, // Ancho del Drawer
        height: double.infinity, // Altura completa
        color: Colors.white, // Color de fondo
        child: Column(
          children: [
            // Encabezado del Drawer sin separación
            Container(
              color: Colors.white, // Color del encabezado
              padding: const EdgeInsets.all(16.0), // Espacio interno
              child: Row(
                children: [
                  // Contenedor cuadrado en lugar de CircleAvatar
                  Container(
                    width: 80, // Ancho del contenedor
                    height: 80, // Altura del contenedor
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/perfil.png'),
                        fit: BoxFit
                            .cover, // Ajusta la imagen al tamaño del contenedor
                      ),
                      borderRadius: BorderRadius.zero, // Sin bordes redondeados
                    ),
                  ),
                  const SizedBox(
                      width: 10), // Espacio entre la imagen y el texto
                  const Expanded(
                    child: Text(
                      'Nombre del Usuario',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Sofia Sans',
                          fontWeight: FontWeight.w900),
                      overflow:
                          TextOverflow.ellipsis, // Manejar el desbordamiento
                    ),
                  ),
                ],
              ),
            ),
            // Opciones de navegación
            _buildListTile(
              icon: Icons.person,
              title: 'Perfil',
              color: const Color(0xff1B1C41), // Color azul
              onTap: () {
                // Lógica para ir a la pantalla de perfil
              },
            ),
            _buildListTile(
              icon: Icons.help,
              title: 'Términos y condiciones',
              color: const Color(0xff1B1C41), // Color azul
              onTap: () {
                // Lógica
              },
            ),
            _buildListTile(
              icon: Icons.info,
              title: 'Eliminar cuenta',
              color: Colors.red, // Color rojo
              onTap: () {
                // Lógica
              },
            ),
            const Spacer(), // Espacio flexible para empujar el footer hacia abajo
            // Cerrar sesión
            _buildListTile(
              icon: Icons.logout,
              title: 'Cerrar sesión',
              color: const Color(0xff1B1C41), // Color azul
              onTap: () {
                // Lógica para cerrar sesión
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
            fontWeight: FontWeight.w400), // Cambia el color del texto aquí
      ),
      onTap: onTap,
    );
  }
}
