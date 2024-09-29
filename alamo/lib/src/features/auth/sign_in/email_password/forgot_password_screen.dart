import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_controller.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emailPasswordSignInControllerProvider);
    final controller = ref.read(emailPasswordSignInControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restablecer Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Introduce tu correo electrónico para recibir un link de restablecimiento de contraseña.'),
              gapH16,
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo no puede estar vacío';
                  }
                  return null;
                },
              ),
              gapH16,
              ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await controller.sendPasswordResetEmail(_emailController.text);
                          if (context.mounted) {
                            // Show confirmation dialog
                            await showAlertDialog(
                              context: context,
                              title: 'Correo enviado',
                              content: 'Te hemos enviado un correo para restablecer tu contraseña.',
                              defaultActionText: 'Aceptar',
                            );
                          }
                        }
                      },
                child: state.isLoading ? const CircularProgressIndicator() : const Text('Enviar enlace de restablecimiento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}