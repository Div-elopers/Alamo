import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_form_type.dart';
import 'package:alamo/src/features/auth/sign_in/string_validators.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';

/// Clase mixin para ser utilizada en la validación de correo electrónico y contraseña del lado del cliente
mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator = MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator = NonEmptyStringValidator();

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(String password, EmailPasswordSignInFormType formType) {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty ? 'El correo electrónico no puede estar vacío'.hardcoded : 'Correo electrónico inválido'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password, EmailPasswordSignInFormType formType) {
    final bool showErrorText = !canSubmitPassword(password, formType);
    final String errorText = password.isEmpty ? 'La contraseña no puede estar vacía'.hardcoded : 'La contraseña es demasiado corta'.hardcoded;
    return showErrorText ? errorText : null;
  }
}
