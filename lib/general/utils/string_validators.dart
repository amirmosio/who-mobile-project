import 'package:flutter/cupertino.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

class StringValidators {
  StringValidators._privateConstructor();

  static String? stringValidator(BuildContext context, String? value) {
    if ((value == null || value.isEmpty)) {
      return AppLocalizations.of(context)!.mandatory_field;
    }
    return null;
  }

  static String? verificationCodeValidator(
    BuildContext context,
    String? value,
    int stringLength, {
    bool isMandatory = true,
  }) {
    if (value == null || value.isEmpty) {
      if (isMandatory) {
        return AppLocalizations.of(context)!.mandatory_field;
      } else {
        return null;
      }
    }
    if (int.tryParse(value) == null) {
      return AppLocalizations.of(context)!.invalid_field;
    } else {
      if (value.length == stringLength) {
        return AppLocalizations.of(context)!.invalid_field;
      }
    }
    return null;
  }

  static String? integerValidator(
    BuildContext context,
    String? value, {
    bool isMandatory = true,
  }) {
    if (value == null || value.isEmpty) {
      if (isMandatory) {
        return AppLocalizations.of(context)!.mandatory_field;
      } else {
        return null;
      }
    }
    if (int.tryParse(value) == null) {
      return AppLocalizations.of(context)!.invalid_field;
    }
    return null;
  }

  static String? emailValidator(
    BuildContext context,
    String? value, {
    bool isMandatory = true,
  }) {
    if (value == null || value.isEmpty) {
      if (isMandatory) {
        return AppLocalizations.of(context)!.mandatory_field;
      } else {
        return null;
      }
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalid_email;
    }
    return null;
  }

  static String? passwordValidator(
    BuildContext context,
    String? value, {
    bool isMandatory = true,
  }) {
    if (value == null || value.isEmpty) {
      if (isMandatory) {
        return AppLocalizations.of(context)!.mandatory_field;
      } else {
        return null;
      }
    }
    final regex = RegExp(r'^(?=.*[a-z])[A-Za-z\d@$!%*?&\.]{4,}$');
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalid_field;
    }
    return null;
  }

  static String? passwordsMatch(
    BuildContext context,
    String? value1,
    String? value2,
  ) {
    if (value1 != value2) {
      return AppLocalizations.of(context)!.passwords_do_not_match;
    }
    return null;
  }

  /// Simple password validator with configurable minimum length (for iOS-style registration)
  /// iOS only requires minimum length without complexity requirements
  static String? simplePasswordValidator(
    BuildContext context,
    String? value, {
    int minLength = 5,
    bool isMandatory = true,
  }) {
    if (value == null || value.isEmpty) {
      if (isMandatory) {
        return AppLocalizations.of(context)!.mandatory_field;
      } else {
        return null;
      }
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Validates phone number with required country code
  /// Must start with + followed by country code (1-3 digits)
  /// Total digits (including country code) must be between 10-15
  /// Example valid formats: +39 1234567890, +1 5551234567, +44 7911123456
  static String? phoneValidator(
    BuildContext context,
    String? value, {
    bool isMandatory = true,
  }) {
    if (value == null || value.isEmpty) {
      if (isMandatory) {
        return AppLocalizations.of(context)!.mandatory_field;
      } else {
        return null;
      }
    }

    // Remove all spaces and non-digit characters except +
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Must start with + (country code is required)
    if (!cleaned.startsWith('+')) {
      return AppLocalizations.of(context)!.phone_must_include_country_code;
    }

    // Extract only digits after the +
    final digitsOnly = cleaned.substring(1).replaceAll(RegExp(r'\D'), '');

    // Total phone number (including country code) should be 10-15 digits
    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return AppLocalizations.of(context)!.invalid_phone_number;
    }

    // Validate format: + followed by 1-3 digit country code, then 7-12 digits
    final regex = RegExp(r'^\+\d{1,3}\s?\d{7,12}$');
    if (!regex.hasMatch(cleaned)) {
      return AppLocalizations.of(context)!.invalid_phone_number;
    }

    return null;
  }

  static String? linkValidator(
    BuildContext context,
    String? value, {
    bool isMandatory = true,
  }) {
    if (value == null || value.isEmpty) {
      if (isMandatory) {
        return AppLocalizations.of(context)!.mandatory_field;
      } else {
        return null;
      }
    }
    final regex = RegExp(
      r'^(https?:\/\/)([\w.-]+)\.([a-zA-Z]{2,6})(\/[@\w.-]*)*\/?$',
    );
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalid_field;
    }
    return null;
  }
}
