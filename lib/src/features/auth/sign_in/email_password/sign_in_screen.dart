import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_validators.dart';
import 'package:alamo/src/features/auth/sign_in/google/google_sign_in_screen.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/widgets/custom_text_button.dart';
import 'package:go_router/go_router.dart';
import 'email_password_sign_in_controller.dart';

final obscurePasswordProvider = StateProvider<bool>((ref) => true);

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(emailPasswordSignInControllerProvider.notifier);
    final validators = EmailAndPasswordValidators();
    final obscurePassword = ref.watch(obscurePasswordProvider);

    final emailFocusNode = FocusNode();
    final passwordFocusNode = FocusNode();
    bool emailTouched = false;
    bool passwordTouched = false;

    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) emailTouched = true;
    });

    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) passwordTouched = true;
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background decorative images
          _buildDecorativeImages(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: kIsWeb ? 600 : double.infinity, // Limit width for web
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage(
                        'assets/images/alamo_logo.png',
                      ),
                    ),
                    gapH64,
                    gapH64,
                    const Text(
                      'Inicia sesión',
                      style: TextStyle(
                        fontFamily: 'SofiaSans',
                        fontSize: 24,
                        color: Colors.black87,
                      ),
                    ),
                    gapH24,
                    _buildTextField(
                      controller: controller.emailController,
                      focusNode: emailFocusNode,
                      labelText: 'Email',
                      errorText: emailTouched ? validators.emailErrorText(controller.emailController.text) : null,
                      onChanged: (text) => emailTouched = text.isNotEmpty,
                    ),
                    gapH16,
                    _buildTextField(
                      controller: controller.passwordController,
                      focusNode: passwordFocusNode,
                      labelText: 'Contraseña',
                      errorText: passwordTouched ? validators.passwordSignInErrorText(controller.passwordController.text) : null,
                      obscureText: obscurePassword,
                      onChanged: (text) {},
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          ref.read(obscurePasswordProvider.notifier).state = !obscurePassword;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                context.pushNamed(AppRoute.forgotPassword.name);
                              },
                        child: const Text(
                          'Olvidé mi contraseña',
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                      ),
                    ),
                    gapH16,
                    if (!kIsWeb)
                      const Row(
                        children: [
                          Expanded(child: Divider(thickness: 1, color: Colors.black, indent: 10)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('o inicia con'),
                          ),
                          Expanded(child: Divider(thickness: 1, color: Colors.black, endIndent: 10)),
                        ],
                      ),
                    gapH16,
                    if (!kIsWeb)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const GoogleSignInScreen(),
                          gapW16,
                          IconButton(
                            icon: const Icon(Icons.apple, size: 48),
                            onPressed: () {
                              _showErrorDialog(context, 'Error', 'No implementado :) ');
                            },
                          ),
                        ],
                      ),
                    gapH16,
                    if (!kIsWeb)
                      CustomTextButton(
                        text: 'Crear nueva cuenta',
                        onPressed: () {
                          context.goNamed(AppRoute.signUp.name);
                        },
                      ),
                    gapH16,
                    ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              if (validators.canSubmitEmail(controller.emailController.text) &&
                                  validators.passwordSignInSubmit(controller.passwordController.text)) {
                                final success = await controller.signIn(
                                  email: controller.emailController.text,
                                  password: controller.passwordController.text,
                                );
                                if (!success && context.mounted) {
                                  _showErrorDialog(context, 'Error', 'Error al iniciar sesión. Verifique sus credenciales.');
                                }
                              } else if (context.mounted) {
                                _showErrorDialog(context, 'Datos inválidos', 'Ingrese un correo y una contraseña válidos.');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 18),
                      ),
                      child: const Text('Iniciar sesión'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show error dialog
  void _showErrorDialog(BuildContext context, String title, String content) {
    showAlertDialog(
      context: context,
      title: title,
      content: Text(content),
      defaultActionText: 'Aceptar',
    );
  }

  // Method to create reusable text field
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
    required void Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        errorText: errorText,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  // Method for background decorative images
  Widget _buildDecorativeImages() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset(
            'assets/images/top_leaf.png',
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset(
            'assets/images/bottom_leaf.png',
          ),
        ),
      ],
    );
  }
}
