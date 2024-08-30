import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_form_type.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_screen.dart';
import 'package:alamo/src/features/auth/sign_in/google/google_sign_in_screen.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:alamo/src/widgets/responsive_center.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar sesión'.hardcoded)),
      body: const ResponsiveCenter(
        child: Column(
          children: [
            EmailPasswordSignInScreen(
              formType: EmailPasswordSignInFormType.signIn,
            ),
            gapH12,
            GoogleSignInScreen(),
          ],
        ),
      ),
    );
  }
}
