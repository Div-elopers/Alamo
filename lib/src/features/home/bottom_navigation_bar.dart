import 'package:alamo/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alamo/src/features/auth/domain/app_user.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final AppUser? user; //

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.map, 'Mapa', 0, context),
          _buildNavItem(Icons.home, 'Inicio', 1, context),
          _buildNavItem(Icons.forum, 'Asistente', 2, context),
          _buildNavItem(Icons.library_books, 'Biblioteca', 3, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index); // Actualiza el índice
        _navigateToScreen(index, context); // Navega a la pantalla correspondiente
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentIndex == index ? const Color(0xff1B1C41) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: currentIndex == index ? const Color(0xff1B1C41) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(AppRoute.map.name);
        break;
      case 1:
        context.goNamed(AppRoute.home.name);
        break;
      case 2:
        context.pushNamed(AppRoute.chats.name, pathParameters: {'userId': user!.uid});
      case 3:
        context.goNamed(AppRoute.library.name);
        break;
    }
  }
}
