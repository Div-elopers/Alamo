import 'package:alamo/src/features/auth/sign_in/string_validators.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';

/// Clase mixin para ser utilizada en la validación de correo electrónico y contraseña del lado del cliente
class EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator = MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator = NonEmptyStringValidator();

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool passwordRegisterSubmit(String password) {
    return passwordRegisterSubmitValidator.isValid(password);
  }

  bool passwordSignInSubmit(String password) {
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty ? 'El correo electrónico no puede estar vacío'.hardcoded : 'Correo electrónico inválido'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordSignUpErrorText(String password) {
    final bool showErrorText = !passwordRegisterSubmit(password);
    final String errorText = password.isEmpty ? 'La contraseña no puede estar vacía'.hardcoded : 'La contraseña es demasiado corta'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordSignInErrorText(String password) {
    final bool showErrorText = !passwordSignInSubmit(password);
    final String errorText = password.isEmpty ? 'La contraseña no puede estar vacía'.hardcoded : 'La contraseña es demasiado corta'.hardcoded;
    return showErrorText ? errorText : null;
  }
}
