import 'package:alamo/src/localization/string_hardcoded.dart';

enum EmailPasswordSignInFormType { signIn, register }

extension EmailPasswordSignInFormTypeX on EmailPasswordSignInFormType {
  String get passwordLabelText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Contraseña (8+ caracteres)'.hardcoded;
    } else {
      return 'Contraseña'.hardcoded;
    }
  }

  // Getters
  String get primaryButtonText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Crear una cuenta'.hardcoded;
    } else {
      return 'Iniciar sesión'.hardcoded;
    }
  }

  String get secondaryButtonText {
    if (this == EmailPasswordSignInFormType.register) {
      return '¿Tienes una cuenta? Inicia sesión'.hardcoded;
    } else {
      return '¿Necesitas una cuenta? Regístrate'.hardcoded;
    }
  }

  String? get optionalThirdButtonText {
    if (this == EmailPasswordSignInFormType.signIn) {
      return '¿Olvidaste tu contraseña?'.hardcoded;
    }
    return null;
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    if (this == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInFormType.signIn;
    } else {
      return EmailPasswordSignInFormType.register;
    }
  }

  String get errorAlertTitle {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Registro fallido'.hardcoded;
    } else {
      return 'Inicio de sesión fallido'.hardcoded;
    }
  }

  String get title {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Registrarse'.hardcoded;
    } else {
      return 'Iniciar sesión'.hardcoded;
    }
  }
}
