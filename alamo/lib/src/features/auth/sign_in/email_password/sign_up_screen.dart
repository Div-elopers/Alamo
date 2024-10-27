import 'package:alamo/src/features/auth/sign_in/email_password/email_password_validators.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:alamo/src/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'email_password_sign_in_controller.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(emailPasswordSignInControllerProvider.notifier);
    final validators = EmailAndPasswordValidators();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: validators.emailErrorText(controller.emailController.text),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    errorText: validators.passwordSignUpErrorText(controller.passwordController.text),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (validators.canSubmitEmail(controller.emailController.text) &&
                        validators.passwordRegisterSubmit(controller.passwordController.text)) {
                      final success = await controller.signUp(email: controller.emailController.text, password: controller.passwordController.text);
                      if (!success && context.mounted) {
                        showAlertDialog(
                          context: context,
                          title: 'Error',
                          content: 'Error al registrarse. Intente nuevamente.',
                          defaultActionText: 'Aceptar',
                        );
                      }
                    } else if (context.mounted) {
                      showAlertDialog(
                        context: context,
                        title: 'Datos inválidos',
                        content: 'Ingrese un correo y una contraseña válidos.',
                        defaultActionText: 'Aceptar',
                      );
                    }
                  },
                  child: const Text('Registrarse'),
                ),
                const SizedBox(height: 12),
                CustomTextButton(
                  text: '¿Ya tienes cuenta? Inicia sesión aquí',
                  onPressed: () {
                    context.goNamed(AppRoute.signIn.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
