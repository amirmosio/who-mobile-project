import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart' show Hint, Sentry;
import 'package:who_mobile_project/general/models/databased_response.dart';
import 'package:who_mobile_project/general/services/network/error_handling_service.dart';
import 'package:who_mobile_project/network/rest_client.dart';

import '../repo_state.dart';

class BaseRepository {
  final RestClient apiClient;
  final Logger logger = Logger();

  BaseRepository(this.apiClient);

  Future<T> raiseExceptionFromRepositoryState<T>(
    Future<DataBasedResponse<T?, BaseMetaData>?> Function() apiCall,
  ) async {
    RepositoryState repo = await getRepositoryState(() => apiCall());
    if (repo is SuccessState) {
      return repo.data!;
    }
    throw RepositoryException(
      error: (repo as ErrorState).exception.error,
      message: '${repo.exception.message}',
    );
  }

  Future<SuccessState<List<T>, PaginatedMetaData>>
  raiseExceptionFromRepositoryStateWithBasePagingResponse<T>(
    Future<DataBasedResponse<List<T>, PaginatedMetaData>?> Function() apiCall,
  ) async {
    RepositoryState repo = await getRepositoryState(() => apiCall());
    if (repo is SuccessState<List<T>, PaginatedMetaData>) {
      return repo;
    }
    throw RepositoryException(
      error: (repo as ErrorState).exception.error,
      message: '${repo.exception.message}',
    );
  }

  Future<RepositoryState> getRepositoryState<T, M extends BaseMetaData>(
    Future<DataBasedResponse<T, M>?> Function() apiCall, {
    Function(DataBasedResponse<T, M>?)? onSuccess,
    Function(RepositoryException)? onError,
  }) {
    late RepositoryException httpRe;
    return apiCall()
        .then((response) {
          if (response?.ok == false) {
            logger.e("ok == false", error: response);
            httpRe = RepositoryException(
              error: response?.errorType,
              message: response?.errorMessage,
            );
            onError?.call(httpRe);
            return ErrorState(httpRe);
          } else {
            // logger.d("ok == true", error: response);
            onSuccess?.call(response);
            return SuccessState<T, M>(
              response?.successData,
              response?.metaData,
            );
          }
        })
        .catchError((error, stackTrace) async {
          await Sentry.captureException(
            error,
            stackTrace: stackTrace,
            hint: Hint.withMap({'source': 'manual_capture_base_repository'}),
          );
          logger.e("catch", error: error, stackTrace: stackTrace);
          if (error.runtimeType != DioException) {
            httpRe = GeneralUtil.getInstance().getHttpRepositoryException(
              DioException(
                type: DioExceptionType.badResponse,
                requestOptions: RequestOptions(),
                error: error.toString(), // Custom error message
              ),
            );
          } else {
            httpRe = GeneralUtil.getInstance().getHttpRepositoryException(
              error,
            );
          }
          onError?.call(httpRe);
          return ErrorState(httpRe);
        });
  }
}
