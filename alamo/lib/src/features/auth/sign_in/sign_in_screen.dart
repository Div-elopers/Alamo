import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_form_type.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_screen.dart';
import 'package:alamo/src/widgets/responsive_center.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: ResponsiveCenter(
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
              //gapH12,
              //GoogleSignInScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
