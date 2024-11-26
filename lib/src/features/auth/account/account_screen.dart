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
import 'package:showcaseview/showcaseview.dart';

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

    GlobalKey emailShowcaseKey = GlobalKey();
    GlobalKey phoneShowcaseKey = GlobalKey();

    return ShowCaseWidget(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: state.isLoading ? const CircularProgressIndicator() : Text('Cuenta'.hardcoded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () {
            ShowCaseWidget.of(context).startShowCase([
              emailShowcaseKey,
              phoneShowcaseKey,
            ]);
          },
          child: const Icon(Icons.info),
        ),
        resizeToAvoidBottomInset: false,
        body: ProfileScreen(
          emailShowcaseKey: emailShowcaseKey,
          phoneShowcaseKey: phoneShowcaseKey,
        ),
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({super.key, required this.emailShowcaseKey, required this.phoneShowcaseKey});
  final validators = EmailAndPasswordValidators();

  final GlobalKey emailShowcaseKey;

  final GlobalKey phoneShowcaseKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(accountScreenControllerProvider.notifier);
    final user = ref.watch(userStreamProvider(ref.watch(authRepositoryProvider).currentUser!.uid)).value;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Future<void> handleImageUpload(File imageFile) async {
      await controller.updateProfilePhoto(imageFile);
    }

    // Text controllers for form fields, initialized with user data
    final nameController = controller.nameController..text = user.name;
    final phoneController = controller.phoneNumberController..text = user.phoneNumber ?? "";
    final emailController = controller.emailController..text = user.email ?? "";
    final departmentController = controller.departmentController..text = user.department ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User photo section
          Center(
            child: ProfilePhoto(
              userProfileUrl:
                  user.profileUrl != "" ? user.profileUrl : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
              onImageUploaded: handleImageUpload,
            ),
          ),
          gapH16,
          _buildTextFormField(
            label: 'Nombre',
            controller: nameController,
            validator: (value) => validators.nameErrorText(value ?? ''),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _buildTextFormField(
                  label: 'Teléfono',
                  keyboardType: const TextInputType.numberWithOptions(),
                  controller: phoneController,
                  validator: (value) {
                    final errorText = validators.phoneNumberErrorText(value ?? '');
                    return errorText;
                  },
                ),
              ),
              user.phoneVerified ? const VerifiedWidget() : VerifyPhoneWidget(phoneController: phoneController, phoneShowcaseKey: phoneShowcaseKey),
            ],
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
              user.emailVerified
                  ? const VerifiedWidget()
                  : VerifyEmailWidget(
                      emailShowcaseKey: emailShowcaseKey,
                    ),
            ],
          ),

          TextButton(
            onPressed: () {
              context.pushNamed(
                AppRoute.forgotPassword.name,
                extra: emailController.text.isNotEmpty ? emailController.text : "",
              );
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
            onPressed: () async {
              final success = await controller.updateProfile(
                uid: user.uid,
                name: nameController.text,
                phoneNumber: phoneController.text,
                department: departmentController.text,
                email: emailController.text,
              );

              if (context.mounted && success) {
                showAlertDialog(
                  context: context,
                  title: 'Perfil Actualizado',
                  defaultActionText: 'OK',
                );
              }
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
        gapH16,
      ],
    );
  }
}

class VerifyEmailWidget extends ConsumerWidget {
  const VerifyEmailWidget({super.key, required this.emailShowcaseKey});

  final GlobalKey emailShowcaseKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountScreenControllerProvider);
    final accountScreenController = ref.read(accountScreenControllerProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Showcase(
          key: emailShowcaseKey,
          title: "Tip! ",
          description: 'Haz click aquí para verificar tu correo.',
          child: IconButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    final success = await accountScreenController.sendEmailVerification();
                    if (context.mounted && success) {
                      showAlertDialog(
                        context: context,
                        title: 'Revisa tu casilla',
                        content: RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                              text: "Te hemos enviado un correo! Después de verificarte, recarga tu usuario en esta pantalla con: ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            WidgetSpan(
                              child: Icon(Icons.refresh, size: 14),
                            ),
                          ]),
                        ),
                        defaultActionText: 'OK',
                      );
                    }
                  },
            icon: const Icon(Icons.verified, color: Colors.grey),
          ),
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

class VerifyPhoneWidget extends StatelessWidget {
  const VerifyPhoneWidget({required this.phoneController, super.key, required this.phoneShowcaseKey});

  final TextEditingController phoneController;

  final GlobalKey phoneShowcaseKey;

  @override
  Widget build(BuildContext context) {
    final phoneNumber = phoneController.text;

    return Showcase(
      key: phoneShowcaseKey,
      title: "Tip! ",
      description: 'Haz click aquí para verificar tu celular.',
      child: IconButton(
        icon: const Icon(Icons.verified),
        color: Colors.grey,
        onPressed: () {
          context.pushNamed(
            AppRoute.verifyPhone.name,
            extra: phoneNumber.isNotEmpty ? phoneNumber : "",
          );
        },
      ),
    );
  }
}
