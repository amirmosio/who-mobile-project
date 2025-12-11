import 'package:flutter/material.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

enum ErrorType {
  /// Network/Connection Errors
  connectionTimeout,
  receiveTimeout,
  communicationProblems,
  notHandled,

  /// Authentication Errors
  unauthorized,
  invalidCredentials,
  accountExpired,
  emailNotRegistered,

  /// Validation Errors
  validationError,
  conflict,

  /// Other Errors
  platformNotFound,
}

extension Error on ErrorType {
  String get identifier {
    switch (this) {
      case ErrorType.connectionTimeout:
        return "Connection Timeout";
      case ErrorType.receiveTimeout:
        return "Receive Timeout";
      case ErrorType.communicationProblems:
        return "Communication Problems";
      case ErrorType.notHandled:
        return "Not Handled";
      case ErrorType.unauthorized:
        return "unauthorized";
      case ErrorType.invalidCredentials:
        return "invalid_credentials";
      case ErrorType.accountExpired:
        return "account_expired";
      case ErrorType.emailNotRegistered:
        return "Email not Registered";
      case ErrorType.validationError:
        return "validation error";
      case ErrorType.conflict:
        return "conflict";
      case ErrorType.platformNotFound:
        return "Platform Not Found";
    }
  }

  String errorMessage(BuildContext context, {List<String?>? args}) {
    switch (this) {
      case ErrorType.connectionTimeout:
        return AppLocalizations.of(context)!.connection_timeout;
      case ErrorType.receiveTimeout:
        return AppLocalizations.of(context)!.receive_timeout;
      case ErrorType.communicationProblems:
        return AppLocalizations.of(context)!.communication_error;
      case ErrorType.notHandled:
        return AppLocalizations.of(context)!.not_handled;
      case ErrorType.unauthorized:
        return AppLocalizations.of(context)!.user_is_not_authorized;
      case ErrorType.invalidCredentials:
        return AppLocalizations.of(context)!.invalid_credentials;
      case ErrorType.accountExpired:
        return AppLocalizations.of(context)!.account_expired;
      case ErrorType.emailNotRegistered:
        return AppLocalizations.of(context)!.email_not_registered;
      case ErrorType.validationError:
        return AppLocalizations.of(context)!.validation;
      case ErrorType.conflict:
        return AppLocalizations.of(context)!.conflict;
      case ErrorType.platformNotFound:
        return AppLocalizations.of(context)!.platform_not_found;
    }
  }
}

ErrorType getByErrorTypeByErrorTypeString(String err) {
  return ErrorType.values.firstWhere((element) {
    return element.identifier == err;
  }, orElse: () => ErrorType.notHandled);
}
