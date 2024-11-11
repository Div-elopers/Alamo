import 'package:alamo/src/features/auth/account/account_screen.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:alamo/src/widgets/responsive_scrollable_card.dart';
import 'package:alamo/src/widgets/custom_button.dart';
import 'package:alamo/src/features/home/bottom_navigation_bar.dart';
import 'package:alamo/src/features/home/cutom_drawer_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentIndexProvider = StateProvider<int>((ref) => 1);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const currentIndex = 1;
    final user = ref.watch(authStateChangesProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 90.0),
          child: Text(
            'Inicio',
            style: TextStyle(
              color: Color(0xff1B1C41),
              fontSize: 20,
              fontFamily: 'Sofia Sanz',
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xff1B1C41)),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the drawer
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xff1B1C41)),
            onPressed: () {
              // Lógica para notificaciones
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildCard(context, 'Tutorial de uso', 'Descripción 1', 'assets/images/image1.png'),
                _buildCard(context, 'Acerca de la app', 'Descripción 2', 'assets/images/image2.png'),
                _buildCard(context, 'Algo más', 'Descripción 3', 'assets/images/image3.png'),
              ],
            ),
          ),
          CustomBottomNavigationBar(
            user: user,
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(currentIndexProvider.notifier).state = index;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String description, String imagePath) {
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
                text: title, // Usa el título directamente
                onPressed: () {
                  showNotImplementedAlertDialog(context: context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
