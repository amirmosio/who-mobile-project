import 'package:dio/dio.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';

class LocaleInterceptor extends Interceptor {
  final StorageManager _storage;

  LocaleInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only set Accept-Language if not already set in the request
    // This allows individual API calls to override the language
    if (!options.headers.containsKey('Accept-Language')) {
      final languageCode = _storage.getLanguageCode() ?? 'it';
      options.headers['Accept-Language'] = languageCode;
    }
    return super.onRequest(options, handler);
  }
}
