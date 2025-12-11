import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/general/constants/api_error_types.dart';
import 'package:who_mobile_project/general/widgets/restart_widget.dart';

class RepositoryState {
  RepositoryState._();
}

class SuccessState<T, M> extends RepositoryState {
  final T? data;
  final M? metaData;

  SuccessState(this.data, this.metaData) : super._();
}

class ErrorState extends RepositoryState {
  ErrorState(this.exception) : super._();
  final RepositoryException exception;
}

class LoadingState extends RepositoryState {
  LoadingState() : super._();
}

class RepositoryException implements Exception {
  final ErrorType? error;
  final String? message;

  RepositoryException({required this.error, this.message});

  String getErrorMessageAndRedirectIfNecessary(BuildContext context) {
    String errorMessage = "";
    if (error != null) {
      errorMessage += error?.errorMessage(context) ?? "";
    }
    if (message != null) {
      if (error != null) {
        errorMessage += "\n";
      }
      errorMessage += message!;
    }

    if (error == ErrorType.unauthorized) {
      GetIt.instance<StorageManager>().removeUserRelatedInfo();
      Future.delayed(Duration(seconds: 5), () {
        // ignore: use_build_context_synchronously
        RestartWidget.restartApp();
      });
    }

    return errorMessage;
  }
}
