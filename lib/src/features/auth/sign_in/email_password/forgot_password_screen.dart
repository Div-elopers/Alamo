import 'dart:developer';

import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_controller.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_validators.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.userEmail});

  final String? userEmail;
  @override
  createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  final validators = EmailAndPasswordValidators();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.userEmail ?? "");
  }

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
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: kIsWeb ? 600 : double.infinity, // Limit width for web
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Introduce tu correo electrónico para recibir un link de restablecimiento de contraseña.'),
                  gapH16,
                  _buildTextFormField(
                    label: 'Email',
                    controller: _emailController,
                    validator: (value) => validators.emailErrorText(value ?? ''),
                  ),
                  gapH16,
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await controller.sendPasswordResetEmail(_emailController.text);

                              // Check if the widget is still mounted before using context
                              if (context.mounted) {
                                // Show confirmation dialog
                                await showAlertDialog(
                                  context: context,
                                  title: 'Correo enviado',
                                  content: const Text('Te hemos enviado un correo para restablecer tu contraseña.'),
                                  defaultActionText: 'Aceptar',
                                );

                                // Ensure the widget is still mounted after dialog
                                if (context.mounted) {
                                  context.goNamed(AppRoute.home.name);
                                }
                              }
                            }
                          },
                    child: state.isLoading ? const CircularProgressIndicator() : const Text('Enviar enlace de restablecimiento'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTextFormField({
  required String label,
  required TextEditingController controller,
  required String? Function(String?) validator,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  Widget? suffixIcon,
  bool readOnly = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      gapH4,
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: readOnly ? Colors.grey.shade200 : Colors.white, // Gray background for readOnly

          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.1, color: Colors.black),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.1, color: Colors.red),
          ),
          focusColor: Colors.transparent,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.1, color: Colors.green),
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        keyboardAppearance: Brightness.light,
        autovalidateMode: AutovalidateMode.onUnfocus,
        readOnly: readOnly,
        inputFormatters: [LengthLimitingTextInputFormatter(35)],
      ),
    ],
  );
}
