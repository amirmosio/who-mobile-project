import 'package:dio/dio.dart';

class ApiVersionInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add API version v3 header to all requests
    options.headers['Accept'] = 'application/json;version=v3';
    return super.onRequest(options, handler);
  }
}
