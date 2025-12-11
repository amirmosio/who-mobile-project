import 'package:equatable/equatable.dart';
import 'package:who_mobile_project/repository/repo_state.dart';

/// Base sealed class for all API states in Riverpod
sealed class BaseApiState extends Equatable {
  const BaseApiState();
}

/// Initial state before any operation
final class BaseApiInitial extends BaseApiState {
  const BaseApiInitial();

  @override
  List<Object> get props => [];
}

/// Loading state during API operations
final class BaseApiLoading extends BaseApiState {
  const BaseApiLoading();

  @override
  List<Object> get props => [];
}

/// Success state with data
final class BaseApiSuccess<T> extends BaseApiState {
  final T data;

  const BaseApiSuccess(this.data);

  @override
  List<Object> get props => [data as Object];
}

/// Error state with exception details
final class BaseApiError extends BaseApiState {
  final RepositoryException exception;

  const BaseApiError(this.exception);

  @override
  List<Object> get props => [exception];
}

/// State for operations that return boolean results (create, update, delete)
final class BaseApiOperationSuccess extends BaseApiState {
  final bool success;
  final String? message;

  const BaseApiOperationSuccess(this.success, [this.message]);

  @override
  List<Object?> get props => [success, message];
}

/// State for list operations with pagination
final class BaseApiListSuccess<T> extends BaseApiState {
  final List<T> items;
  final int totalCount;
  final bool hasMore;
  final int currentPage;

  const BaseApiListSuccess({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    required this.currentPage,
  });

  BaseApiListSuccess<T> copyWith({
    List<T>? items,
    int? totalCount,
    bool? hasMore,
    int? currentPage,
  }) {
    return BaseApiListSuccess<T>(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [items, totalCount, hasMore, currentPage];
}

/// Extension to provide a when method for pattern matching
extension BaseApiStateExtension on BaseApiState {
  T when<T>({
    required T Function() initial,
    required T Function(String? message) loading,
    required T Function(dynamic data) success,
    required T Function(String message, RepositoryException? exception) error,
  }) {
    final state = this;
    if (state is BaseApiInitial) {
      return initial();
    } else if (state is BaseApiLoading) {
      return loading(null);
    } else if (state is BaseApiSuccess) {
      return success(state.data);
    } else if (state is BaseApiError) {
      return error(
        state.exception.message ?? 'An error occurred',
        state.exception,
      );
    }
    return initial(); // Fallback
  }
}
