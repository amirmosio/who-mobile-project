import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/repository/repo_state.dart';

/// Base Riverpod Notifier for API operations with common patterns
/// Similar to BaseApiCubit but using Riverpod
abstract class BaseApiNotifier<T extends BaseApiState> extends Notifier<T> {
  final Logger _logger = Logger();

  @override
  T build();

  /// Execute an API call that returns data
  Future<K?> executeApiCallAndSetState<K>(
    Future<RepositoryState> Function() apiCall, {
    String? loadingMessage,
    String? successMessage,
  }) async {
    try {
      state = _createLoadingState() as T;

      final response = await apiCall();

      if (response is SuccessState) {
        final data = response.data;
        state = _createSuccessState<K>(data, successMessage) as T;
        return data as K;
      } else if (response is ErrorState) {
        _logger.e('API call failed', error: response.exception);
        state = _createErrorState(response.exception) as T;
        return null;
      }
      return null;
    } catch (e) {
      if (e is RepositoryException) {
        state = _createErrorState(e) as T;
      } else {
        final exception = RepositoryException(
          message: e.toString(),
          error: null,
        );
        state = _createErrorState(exception) as T;
      }

      return null;
    }
  }

  /// Execute an API operation that returns boolean (create, update, delete)
  Future<bool> executeOperationAndSetState(
    Future<RepositoryState> Function() operation, {
    String? loadingMessage,
    String? successMessage,
    String? errorMessage,
    void Function()? onSuccess,
  }) async {
    try {
      state = _createLoadingState() as T;

      final response = await operation();

      if (response is SuccessState) {
        state =
            _createOperationSuccessState(
                  true,
                  successMessage ?? 'Operation completed successfully',
                )
                as T;
        onSuccess?.call();
        return true;
      } else if (response is ErrorState) {
        _logger.e('Operation failed', error: response.exception);

        state = _createErrorState(response.exception) as T;
        return false;
      }
      return false;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error during operation',
        error: e,
        stackTrace: stackTrace,
      );
      final exception = RepositoryException(message: e.toString(), error: null);
      state = _createErrorState(exception) as T;
      return false;
    }
  }

  /// Helper method to check if current state is loading
  bool get isLoading => state is BaseApiLoading;

  /// Helper method to check if current state is error
  bool get hasError => state is BaseApiError;

  /// Helper method to get exception if in error state
  RepositoryException? get exception =>
      state is BaseApiError ? (state as BaseApiError).exception : null;

  /// Override this method to provide custom error message mapping
  /// This allows specific providers to handle known error patterns
  String getCustomErrorMessage(
    RepositoryException exception,
    String defaultMessage,
  ) {
    return defaultMessage;
  }

  /// Default implementations of state creation methods
  BaseApiState _createLoadingState() => const BaseApiLoading();
  BaseApiState _createSuccessState<K>(K data, String? message) =>
      BaseApiSuccess<K>(data);
  BaseApiState _createErrorState(RepositoryException exception) =>
      BaseApiError(exception);
  BaseApiState _createOperationSuccessState(bool success, String message) =>
      BaseApiOperationSuccess(success, message);
}
