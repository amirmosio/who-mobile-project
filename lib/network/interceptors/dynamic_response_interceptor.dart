import 'dart:convert';

import 'package:dio/dio.dart';

/// Interceptor to handle APIs that can return either Map or List responses
/// This fixes the issue where auto-generated Retrofit code expects Map
/// but some APIs return List directly
class DynamicResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Only wrap non-Map responses if status code indicates success
    if (response.data is! Map) {
      if (response.data is String) {
        try {
          response.data = json.decode(response.data);
        } catch (e) {
          response.data = response.data;
        }
      }
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        response.data = {'data': response.data, 'ok': true};
      } else {
        response.data = {'error': response.data, 'ok': false};
      }
    }

    handler.next(response);
  }
}
