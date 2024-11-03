import 'dart:io';
import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/constants/departments.dart';
import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_validators.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/utils/async_value_ui.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:alamo/src/widgets/dropdown_dialog.dart';
import 'package:alamo/src/widgets/profile_photo.dart';
import 'package:alamo/src/widgets/responsive_center.dart';
import 'package:alamo/src/widgets/verified.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: state.isLoading ? const CircularProgressIndicator() : Text('Cuenta'.hardcoded),
      ),
      body: ResponsiveCenter(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        child: ProfileScreen(),
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({super.key});
  final validators = EmailAndPasswordValidators(); // Add validators instance

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(accountScreenControllerProvider.notifier);
    final user = ref.watch(userStreamProvider(ref.watch(authRepositoryProvider).currentUser!.uid)).value;

    if (user == null) {
      return const Center(child: CircularProgressIndicator()); // Loading indicator while user data is fetched
    }

    Future<void> handleImageUpload(File imageFile) async {
      await controller.updateProfilePhoto(imageFile);
    }

    // Text controllers for form fields, initialized with user data
    final nameController = controller.nameController..text = user.name;
    final phoneController = controller.phoneNumberController..text = user.phoneNumber ?? "";
    final emailController = controller.emailController..text = user.email ?? "";
    final departmentController = controller.departmentController..text = user.department ?? "";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User photo section
          Center(
            child: ProfilePhoto(
              userProfileUrl: user.profileUrl ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
              onImageUploaded: handleImageUpload,
            ),
          ),
          gapH16,
          _buildTextFormField(
            label: 'Nombre',
            controller: nameController,
            validator: (value) => validators.nameErrorText(value ?? ''),
          ),
          _buildTextFormField(
            label: 'Teléfono',
            keyboardType: const TextInputType.numberWithOptions(),
            controller: phoneController,
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

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Email Text Field
              Expanded(
                child: _buildTextFormField(
                  label: 'Email',
                  controller: emailController,
                  validator: (value) => validators.emailErrorText(value ?? ''),
                  readOnly: true,
                ),
              ),
              gapW8,
              // Verification Widget
              user.emailVerified ? const VerifiedWidget(type: "Email") : const VerifyEmailWidget(),
            ],
          ),

          TextButton(
            onPressed: () {
              showNotImplementedAlertDialog(context: context);
            },
            child: const Text('Cambiar contraseña'),
          ),
          TextButton(
            onPressed: () {
              showNotImplementedAlertDialog(context: context);
            },
            child: const Text('Solicitar datos personales'),
          ),

          ElevatedButton(
            onPressed: () {
              controller.updateProfile(
                name: nameController.text,
                phoneNumber: phoneController.text,
                department: departmentController.text,
                email: emailController.text,
              );
              showNotImplementedAlertDialog(context: context);
            },
            child: const Text('Guardar cambios'),
          ),
        ],
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
          readOnly: readOnly,
          inputFormatters: [LengthLimitingTextInputFormatter(35)],
        ),
        gapH16,
      ],
    );
  }
}

class VerifyEmailWidget extends ConsumerWidget {
  const VerifyEmailWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountScreenControllerProvider);
    final accountScreenController = ref.read(accountScreenControllerProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: state.isLoading
              ? null
              : () async {
                  final success = await accountScreenController.sendEmailVerification();
                  if (context.mounted && success) {
                    showAlertDialog(
                      context: context,
                      title: "Enviado - revisa tu casilla de correo".hardcoded,
                    );
                  }
                },
          icon: state.isLoading ? const CircularProgressIndicator() : const Icon(Icons.check_circle, color: Colors.grey),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () async {
            await accountScreenController.reloadUserAndSyncWithFirestore();
          },
        ),
      ],
    );
  }
}

class VerifyPhoneWidget extends ConsumerWidget {
  const VerifyPhoneWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountScreenControllerProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    context.goNamed(
                      AppRoute.verifyPhone.name,
                    );
                  },
            child: Text("Verificar numero de telefono".hardcoded))
      ],
    );
  }
}
