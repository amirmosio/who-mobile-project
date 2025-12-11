import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:who_mobile_project/general/services/device/device_service.dart';

enum Environment {
  local,
  staging,
  prod;

  String get name {
    switch (this) {
      case Environment.local:
        return 'local';
      case Environment.staging:
        return 'staging';
      case Environment.prod:
        return 'production';
    }
  }
}

class StoreUrlConstants {
  static const _android =
      "https://play.google.com/store/apps/details?id=com.bokapp.quizpatente";
  static const _ios =
      "https://apps.apple.com/it/app/quiz-patente-ufficiale-2025/id635361447?l=en-GB";

  static String get storeUrl {
    if (DeviceUtils.getInstance().isAndroid) {
      return _android;
    } else if (DeviceUtils.getInstance().isIos) {
      return _ios;
    }
    throw Exception("Device not supported");
  }
}

class Constants {
  static late Map<String, dynamic> _config;
  static late Environment env;

  static void setEnvironment(Environment env) {
    Constants.env = env;
    switch (env) {
      case Environment.local:
        _config = NetworkAddressConfig.localConstants;
        break;
      case Environment.staging:
        _config = NetworkAddressConfig.stagingConstants;
        break;
      case Environment.prod:
        _config = NetworkAddressConfig.prodConstants;
        break;
    }
  }

  static get baseUrl {
    return _config[NetworkAddressConfig.baseUrl];
  }

  static get baseSocketUrl {
    return _config[NetworkAddressConfig.baseSocketUrl];
  }

  static get apiDomain {
    return NetworkAddressConfig.apiDomain;
  }

  static get domain {
    String baseUrl = (_config[NetworkAddressConfig.baseUrl] as String);
    if (baseUrl.endsWith("/")) {
      return baseUrl.substring(0, baseUrl.length - 1);
    }
    return baseUrl;
  }

  // OneSignal App ID from .env
  static String get oneSignalAppId => dotenv.env['ONESIGNAL_APP_ID'] ?? '';

  // Redvertising configuration
  // Matches iOS: CommonController.swift redvertisingBaseUrl and redvertisingAppID
  static const String redvertisingBaseUrl =
      'https://redvertising.reddoak.com/api/';
  static const String redvertisingAppId =
      '32cec605-64dc-4865-9b9f-70d44d7a80b7';
}

class NetworkAddressConfig {
  static const baseUrl = "BASE_URL";
  static const baseSocketUrl = "BASE_SOCKET_URL";

  // String apiDomain = "http://127.0.0.1:8000";
  // String socketDomain = "ws://127.0.0.1:8000";
  // String apiDomain = "http://10.0.2.2:8000";
  // String socketDomain = "ws://10.0.2.2:8000";
  // String apiDomain = "https://b6540ddea8ae.ngrok-free.app";
  // String socketDomain = "wss://b6540ddea8ae.ngrok-free.app";
  static String apiDomain = "https://staging.guidaevai.com";
  static String socketDomain = "wss://staging.guidaevai.com";

  static Map<String, dynamic> localConstants = {
    baseUrl: "$apiDomain/api/v2/",
    baseSocketUrl: "$socketDomain/api/v2/",
  };

  static Map<String, dynamic> stagingConstants = {
    baseUrl: "https://staging.guidaevai.com/api/v2/",
    baseSocketUrl: "wss://staging.guidaevai.com/api/v2/",
  };

  static Map<String, dynamic> prodConstants = {
    baseUrl: "https://google.ai/api/v1/",
    baseSocketUrl: "wss://google.ai/api/v1/",
  };
}
