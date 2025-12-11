import 'package:dio/dio.dart';
import 'package:who_mobile_project/app_core/authenticator/shared_preferences_authenticator.dart';
import 'package:who_mobile_project/network/interceptors/refresh_token_interceptor.dart';

class AuthorizationInterceptor extends Interceptor {
  final SharedPreferencesAuthenticator _authenticator;

  AuthorizationInterceptor(this._authenticator);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.validateStatus = validateStatus;

    String? token = await _authenticator.peekAuthToken();
    bool pathMatched = RefreshTokenInterceptor.ignorePathsForToken.any((
      element,
    ) {
      return element.hasMatch(options.path);
    });
    if (token != null && !pathMatched) {
      options.headers['Authorization'] = "Bearer $token";
    }

    return super.onRequest(options, handler);
  }

  static bool validateStatus(int? status) {
    return true;
  }
}
