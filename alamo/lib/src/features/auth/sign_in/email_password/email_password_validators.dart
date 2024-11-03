import 'dart:developer';

import 'package:alamo/src/features/auth/sign_in/string_validators.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator = MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator = NonEmptyStringValidator();
  final StringValidator nameValidator = NonEmptyStringValidator();
  final StringValidator phoneNumberValidator = PhoneNumberRegexValidator();
  final StringValidator departmentValidator = NonEmptyStringValidator();

  bool canSubmitEmail(String email) => emailSubmitValidator.isValid(email);
  bool passwordRegisterSubmit(String password) => passwordRegisterSubmitValidator.isValid(password);
  bool passwordSignInSubmit(String password) => passwordSignInSubmitValidator.isValid(password);
  bool canSubmitName(String name) => nameValidator.isValid(name);
  bool canSubmitphoneNumber(String phoneNumber) => phoneNumberValidator.isValid(phoneNumber);
  bool canSubmitDepartment(String department) => departmentValidator.isValid(department);

  String? emailErrorText(String email) {
    final showErrorText = !canSubmitEmail(email);
    return showErrorText ? (email.isEmpty ? 'El correo electrónico no puede estar vacío'.hardcoded : 'Correo electrónico inválido'.hardcoded) : null;
  }

  String? passwordSignUpErrorText(String password) {
    final showErrorText = !passwordRegisterSubmit(password);
    return showErrorText ? (password.isEmpty ? 'La contraseña no puede estar vacía'.hardcoded : 'La contraseña es demasiado corta'.hardcoded) : null;
  }

  String? passwordSignInErrorText(String password) {
    final showErrorText = !passwordSignInSubmit(password);
    return showErrorText ? (password.isEmpty ? 'La contraseña no puede estar vacía'.hardcoded : 'La contraseña es demasiado corta'.hardcoded) : null;
  }

  String? nameErrorText(String name) {
    final showErrorText = !canSubmitName(name);
    return showErrorText ? 'Por favor ingresa tu nombre'.hardcoded : null;
  }

  String? phoneNumberErrorText(String phoneNumber) {
    try {
      final parsedNumber = PhoneNumber.parse(phoneNumber, callerCountry: IsoCode.UY);
      if (!parsedNumber.isValid()) {
        return 'Ingrese un número de teléfono uruguayo válido';
      }
      return null;
    } catch (e) {
      return 'Ingrese un número de teléfono válido';
    }
  }

  String? departmentErrorText(String department) {
    final showErrorText = !canSubmitDepartment(department);
    return showErrorText ? 'Por favor selecciona un Departamento'.hardcoded : null;
  }

  String? repeatPasswordErrorText(String password, String repeatPassword) {
    final showErrorText = password != repeatPassword;
    return showErrorText ? 'Las contraseñas no coinciden'.hardcoded : null;
  }
}
