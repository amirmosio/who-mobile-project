import 'package:dio/dio.dart';
import 'package:who_mobile_project/app_core/authenticator/shared_preferences_authenticator.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/app_core/config/environment_constants.dart'
    as env_const;
import 'package:who_mobile_project/general/services/device/device_service.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/network/device_info.dart';
import 'package:who_mobile_project/network/interceptors/api_version_interceptor.dart';
import 'package:who_mobile_project/network/interceptors/authorization_interceptor.dart';
import 'package:who_mobile_project/network/interceptors/locale_interceptor.dart';
import 'package:who_mobile_project/network/interceptors/refresh_token_interceptor.dart';
import 'package:who_mobile_project/network/interceptors/network_blocker_interceptor.dart';
import 'package:who_mobile_project/network/interceptors/dynamic_response_interceptor.dart';
import 'package:who_mobile_project/network/rest_client.dart';
import 'package:who_mobile_project/network/redvertising_client.dart';

const baseUrl = '#baseUrl';
const redvertisingBaseUrl = '#redvertisingBaseUrl';
const deviceId = '#deviceId';
const token = '#token';

@module
abstract class NetworkModule {
  @singleton
  RestClient clientProvider(Dio dio, @Named(baseUrl) String url) {
    return RestClient(dio, baseUrl: url);
  }

  @singleton
  RedvertisingClient redvertisingClientProvider(
    @Named(redvertisingBaseUrl) String url,
  ) {
    // Create separate Dio instance for Redvertising API without interceptors
    final dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 40);
    dio.options.receiveTimeout = Duration(seconds: 45);
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
      ),
    );
    return RedvertisingClient(dio, baseUrl: url);
  }

  @injectable
  @Named(baseUrl)
  String baseUrlProvider() {
    return "${env_const.Constants.baseUrl}";
  }

  @injectable
  @Named(redvertisingBaseUrl)
  String redvertisingBaseUrlProvider() {
    return env_const.Constants.redvertisingBaseUrl;
  }

  @singleton
  Dio dioProvider(
    DeviceOrBrowserInfo deviceInfo,
    ApiVersionInterceptor apiVersionInterceptor,
    AuthorizationInterceptor serviceInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
    LocaleInterceptor localInterceptor,
  ) {
    var dio = Dio();
    dio.options.headers['user-agent'] =
        "${deviceInfo.operatingSystem}/${deviceInfo.operatingSystemVersion}";
    dio.options.headers['X-Device-ID'] = deviceInfo.id;
    dio.options.connectTimeout = Duration(seconds: 40);
    dio.options.receiveTimeout = Duration(seconds: 45);

    List<Interceptor> interceptors = [
      NetworkBlockerInterceptor(), // Add this first to block all requests when disabled
      DynamicResponseInterceptor(), // Handle APIs that return List directly
      apiVersionInterceptor,
      refreshTokenInterceptor,
      serviceInterceptor,
      localInterceptor,
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
      ),
    ];
    for (var interceptor in interceptors) {
      dio.interceptors.add(interceptor);
    }
    return dio;
  }

  @preResolve
  @singleton
  Future<DeviceOrBrowserInfo> getDeviceInfo() async {
    return await DeviceUtils.getInstance().getDeviceInfo();
  }

  @singleton
  AuthorizationInterceptor serviceInterceptorProvider(
    SharedPreferencesAuthenticator authenticator,
  ) => AuthorizationInterceptor(authenticator);

  @singleton
  LocaleInterceptor localeInterceptorProvider(StorageManager storage) =>
      LocaleInterceptor(storage);

  @singleton
  RefreshTokenInterceptor refreshTokenInterceptorProvider(
    DeviceOrBrowserInfo deviceInfo,
    SharedPreferencesAuthenticator authenticator,
  ) => RefreshTokenInterceptor(deviceInfo, authenticator);

  @singleton
  ApiVersionInterceptor apiVersionInterceptorProvider() =>
      ApiVersionInterceptor();
}
