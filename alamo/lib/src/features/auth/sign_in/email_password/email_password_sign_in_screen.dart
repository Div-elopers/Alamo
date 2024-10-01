import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_controller.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_validators.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_form_type.dart';
import 'package:alamo/src/features/auth/sign_in/string_validators.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/utils/async_value_ui.dart';
import 'package:alamo/src/widgets/custom_text_button.dart';
import 'package:alamo/src/widgets/primary_button.dart';
import 'package:alamo/src/widgets/responsive_scrollable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Email & password sign in screen.
/// Wraps the [EmailPasswordSignInContents] widget below with a [Scaffold] and
/// [AppBar] with a title.
class EmailPasswordSignInScreen extends StatelessWidget {
  const EmailPasswordSignInScreen({super.key, required this.formType});
  final EmailPasswordSignInFormType formType;

  // * Keys for testing using find.byKey()
  static const emailKey = Key('email');
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) {
    return EmailPasswordSignInContents(
      formType: formType,
    );
  }
}

class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  const EmailPasswordSignInContents({
    super.key,
    this.onSignedIn,
    required this.formType,
  });
  final VoidCallback? onSignedIn;

  /// The default form type to use.
  final EmailPasswordSignInFormType formType;
  @override
  ConsumerState<EmailPasswordSignInContents> createState() =>
      _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState
    extends ConsumerState<EmailPasswordSignInContents>
    with EmailAndPasswordValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  var _submitted = false;
  late var _formType = widget.formType;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller =
          ref.read(emailPasswordSignInControllerProvider.notifier);
      final success = await controller.submit(
        email: email,
        password: password,
        formType: _formType,
      );
      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType() {
    // * Toggle between register and sign in form
    setState(() => _formType = _formType.secondaryActionFormType);
    // * Clear the password field when doing so
    _passwordController.clear();
  }

  /*@override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      emailPasswordSignInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(emailPasswordSignInControllerProvider);
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              gapH8,
              // Email field
              TextFormField(
                key: EmailPasswordSignInScreen.emailKey,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email'.hardcoded,
                  enabled: !state.isLoading,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => !_submitted ? null : emailErrorText(email ?? ''),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _emailEditingComplete(),
                inputFormatters: <TextInputFormatter>[
                  ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator()),
                ],
              ),
              gapH8,
              // Password field
              TextFormField(
                key: EmailPasswordSignInScreen.passwordKey,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: _formType.passwordLabelText,
                  enabled: !state.isLoading,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => !_submitted ? null : passwordErrorText(password ?? '', _formType),
                obscureText: true,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _passwordEditingComplete(),
              ),
              gapH8,
              PrimaryButton(
                text: _formType.primaryButtonText,
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : () => _submit(),
              ),
              gapH8,
              CustomTextButton(
                text: _formType.secondaryButtonText,
                onPressed: state.isLoading ? null : _updateFormType,
              ),
              if (_formType.optionalThirdButtonText != null)
                CustomTextButton(
                  text: _formType.optionalThirdButtonText!,
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.goNamed(AppRoute.forgotPassword.name);
                        },
                ),
            ],
          ),
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      emailPasswordSignInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(emailPasswordSignInControllerProvider);

    return Padding(
      padding: const EdgeInsets.only(
          left: 16), // Padding a la izquierda de toda la columna
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B1C41),
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            key: EmailPasswordSignInScreen.emailKey,
            controller: _emailController,
            decoration: InputDecoration(
              enabled: !state.isLoading,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFBEBFDA)),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                !_submitted ? null : emailErrorText(email ?? ''),
            autocorrect: false,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            keyboardAppearance: Brightness.light,
            inputFormatters: <TextInputFormatter>[
              ValidatorInputFormatter(
                  editingValidator: EmailEditingRegexValidator()),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Contraseña',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B1C41),
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            key: EmailPasswordSignInScreen.passwordKey,
            controller: _passwordController,
            decoration: InputDecoration(
              enabled: !state.isLoading,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFBEBFDA)),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (password) => !_submitted
                ? null
                : passwordErrorText(password ?? '', _formType),
            obscureText: true,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            keyboardAppearance: Brightness.light,
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Olvidé mi contraseña',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1B1C41),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: state.isLoading ? null : _submit,
            child: Container(
              width: 322,
              height: 46,
              decoration: BoxDecoration(
                color: state.isLoading ? Colors.grey : const Color(0xFF1B1C41),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Center(
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFAFAFA),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          CustomTextButton(
            text: _formType.secondaryButtonText,
            onPressed: state.isLoading ? null : _updateFormType,
          ),
          /* if (_formType.optionalThirdButtonText != null)
            CustomTextButton(
              text: _formType.optionalThirdButtonText!,
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.goNamed(AppRoute.forgotPassword.name);
                    },
            ),*/
        ],
      ),
    );
  }
}
