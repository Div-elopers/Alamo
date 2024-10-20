import 'package:alamo/src/features/auth/account/account_screen.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/register_screen.dart';
//import 'package:alamo/src/features/home/home_app_bar/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:alamo/src/widgets/responsive_scrollable_card.dart';
import 'package:alamo/src/widgets/custom_button.dart';
import 'package:alamo/src/features/home/home_app_bar/bottom_navigation_bar.dart';
import 'package:alamo/src/features/auth/account/cutom_drawer_screen.dart';
/*class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: Placeholder(),
    );
  }
}*/

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Para gestionar el índice de navegación

  @override
  Widget build(BuildContext context) {
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
      drawer: const CustomDrawer(), // Usa el widget CustomDrawer aquí
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Aquí van las cards
                _buildCard(context, 'Tutorial de uso', 'Descripción 1',
                    'assets/images/image1.png'),
                _buildCard(context, 'Acerca de la app', 'Descripción 2',
                    'assets/images/image2.png'),
                _buildCard(context, 'Algo más', 'Descripción 3',
                    'assets/images/image3.png'),
              ],
            ),
          ),
          CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                // Lógica para cambiar de pantalla según el índice
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String description,
      String imagePath) {
    return ResponsiveScrollableCard(
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 200,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
