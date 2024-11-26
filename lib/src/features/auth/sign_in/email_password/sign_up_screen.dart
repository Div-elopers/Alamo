import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/constants/departments.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_controller.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:alamo/src/widgets/dropdown_dialog.dart';
import 'package:alamo/src/widgets/primary_button.dart';
import 'package:alamo/src/widgets/responsive_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'email_password_validators.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

  // Key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final validators = EmailAndPasswordValidators(); // Add validators instance

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(emailPasswordSignInControllerProvider.notifier);
    final isLoading = ref.watch(emailPasswordSignInControllerProvider).isLoading;
    final obscurePassword = ref.watch(obscurePasswordProvider);
    final obscureRepeatPassword = ref.watch(obscureRepeatPasswordProvider);

    final nameController = controller.nameController;
    final phoneNumberController = controller.phoneNumberController;
    final departmentController = controller.departmentController;
    final emailController = controller.emailController;
    final passwordController = controller.passwordController;
    final repeatpassController = controller.repeatpassController;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de usuario',
          style: TextStyle(fontSize: 20, fontFamily: 'Sofia Sans'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: ResponsiveCenter(
            child: FocusScope(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildTextFormField(
                      label: 'Nombre',
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      validator: (value) => validators.nameErrorText(value ?? ''),
                    ),
                    _buildTextFormField(
                      label: 'Teléfono',
                      keyboardType: const TextInputType.numberWithOptions(),
                      controller: phoneNumberController,
                      validator: (value) => validators.phoneNumberErrorText(value ?? ''),
                    ),
                    const Text(
                      'Departamento',
                    ),
                    gapH4,
                    AdaptiveDropdown(
                      value: departmentController.text.isNotEmpty ? departmentController.text : null,
                      items: uruguayDepartments,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          departmentController.text = newValue;
                        }
                      },
                      validator: (value) => validators.departmentErrorText(value!),
                    ),
                    gapH16,
                    _buildTextFormField(
                      label: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => validators.emailErrorText(value ?? ''),
                    ),
                    _buildTextFormField(
                      label: 'Contraseña',
                      controller: passwordController,
                      obscureText: obscurePassword,
                      validator: (value) => validators.passwordSignUpErrorText(value ?? ''),
                      suffixIcon: passwordSuffixIcon(obscurePassword, ref, obscurePasswordProvider),
                    ),
                    _buildTextFormField(
                      label: 'Repetir contraseña',
                      controller: repeatpassController,
                      obscureText: obscureRepeatPassword,
                      validator: (value) => validators.repeatPasswordErrorText(
                        passwordController.text,
                        value ?? '',
                      ),
                      suffixIcon: passwordSuffixIcon(obscureRepeatPassword, ref, obscureRepeatPasswordProvider),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Al registrarse está de acuerdo con los términos y condiciones',
                        style: TextStyle(
                          fontFamily: 'Sofia Sans',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    gapH32,
                    PrimaryButton(
                      text: 'Crear usuario',
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final success = await controller.signUp(
                                  name: nameController.text.trim(),
                                  phoneNumber: phoneNumberController.text.trim(),
                                  department: departmentController.text,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  repeatPassword: repeatpassController.text.trim(),
                                );

                                if (success) {
                                  if (context.mounted) {
                                    context.go('/');
                                  }
                                } else {
                                  if (context.mounted) {
                                    // Optionally show an error message
                                    showAlertDialog(
                                      context: context,
                                      title: 'Fallo la creación de usuario',
                                      content: const Text('Por favor, revisa la información.'),
                                      defaultActionText: 'OK',
                                    );
                                  }
                                }
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        gapH4,
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
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
        ),
        gapH16,
      ],
    );
  }

  IconButton passwordSuffixIcon(bool obscurePassword, WidgetRef ref, StateProvider provider) {
    return IconButton(
      icon: Icon(
        obscurePassword ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        ref.read(provider.notifier).state = !obscurePassword;
      },
    );
  }
}

final obscurePasswordProvider = StateProvider<bool>((ref) => true);
final obscureRepeatPasswordProvider = StateProvider<bool>((ref) => true);
