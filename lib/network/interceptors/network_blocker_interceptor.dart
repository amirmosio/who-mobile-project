import 'package:dio/dio.dart';

/// Interceptor that can block all network requests programmatically
class NetworkBlockerInterceptor extends Interceptor {
  static bool _isNetworkDisabled = false;

  /// Enable or disable network requests
  static void setNetworkEnabled(bool enabled) {
    _isNetworkDisabled = !enabled;
  }

  /// Check if network is currently enabled
  static bool get isNetworkEnabled => !_isNetworkDisabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isNetworkDisabled) {
      // Block the request and return an error response
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Network disabled',
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }

    // Network is enabled, proceed with the request
    handler.next(options);
  }
}
