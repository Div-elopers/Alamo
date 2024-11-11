import 'package:alamo/src/features/auth/sign_in/string_validators.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class HelpCenterValidators {
  final StringValidator stringValidator = NonEmptyStringValidator();

  bool canSubmitName(String name) => stringValidator.isValid(name);

  String? nameErrorText(String name) {
    final showErrorText = !canSubmitName(name);
    return showErrorText ? 'Por favor completa el dato.'.hardcoded : null;
  }

  final StringValidator phoneNumberValidator = PhoneNumberRegexValidator();

  bool canSubmitphoneNumber(String phoneNumber) => phoneNumberValidator.isValid(phoneNumber);

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

  final StringValidator categoryValidator = NonEmptyStringValidator();

  bool canSubmitCategory(String category) => categoryValidator.isValid(category);

  String? categoryErrorText(String category) {
    final showErrorText = !canSubmitCategory(category);
    return showErrorText ? 'Por favor selecciona una categoria'.hardcoded : null;
  }
}
