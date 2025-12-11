import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

/// Token in the investor properties path
@RestApi(baseUrl: "")
abstract class RestClient {
  static const String httpAPIVersion2 = "2";

  factory RestClient(Dio dio, {String? baseUrl}) {
    return _RestClient(dio, baseUrl: baseUrl, errorLogger: null);
  }

}
