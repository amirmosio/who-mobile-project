import 'package:dio/dio.dart';
import 'package:who_mobile_project/app_core/authenticator/shared_preferences_authenticator.dart';
import 'package:who_mobile_project/app_core/config/environment_constants.dart'
    as env_const;
import 'package:who_mobile_project/general/models/databased_response.dart';
import 'package:who_mobile_project/general/models/login/login_response.dart';
import 'package:who_mobile_project/network/device_info.dart';
import 'package:who_mobile_project/network/rest_client.dart';

class RefreshTokenInterceptor extends Interceptor {
  static List<RegExp> ignorePathsForToken = [
    RegExp(r"^/versioning/.*/$"),
    RegExp(r"^/auth/token$"),
    RegExp(r"^/authentication/jwt/login/$"),
    RegExp(r"^/authentication/social/apple/$"),
    RegExp(r"^/authentication/social/google/$"),
    RegExp(r"^/social/facebook$"),
    RegExp(r"^/authentication/jwt/refresh/$"),
    RegExp(r"^/authentication/exchange/legacy-token/$"),
  ];
  final DeviceOrBrowserInfo _deviceInfo;
  final SharedPreferencesAuthenticator _authenticator;
  late final RestClient _refreshClient;

  RefreshTokenInterceptor(this._deviceInfo, this._authenticator) {
    // Create a dedicated Dio instance for refresh token calls to avoid circular dependency
    final refreshDio = _createRefreshDio();
    _refreshClient = RestClient(
      refreshDio,
      baseUrl: env_const.Constants.baseUrl,
    );
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: Removed - Token refresh no longer available
    // All token validation and refresh logic disabled
    return handler.next(options);
  }

  Dio _createRefreshDio() {
    final dio = Dio();
    dio.options.headers['user-agent'] =
        "${_deviceInfo.operatingSystem}/${_deviceInfo.operatingSystemVersion}";
    dio.options.headers['X-Device-ID'] = _deviceInfo.id;
    dio.options.connectTimeout = Duration(seconds: 40);
    dio.options.receiveTimeout = Duration(seconds: 45);

    // Only add logging interceptor to avoid circular dependencies
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
      ),
    );

    return dio;
  }

  // TODO: Removed - Token refresh no longer available
  Future<DataBasedResponse<RefreshTokenResponse, BaseMetaData>>
  refreshTokenAndUpdateStorage() async {
    // Token refresh endpoint removed from API
    throw Exception('Token refresh not available');
  }
}
