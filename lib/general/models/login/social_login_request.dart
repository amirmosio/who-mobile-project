import 'package:who_mobile_project/general/constants/login_methods.dart';

abstract class SocialAuthRequest {
  final String token;
  final String firstname;
  final String surname;

  SocialAuthRequest({
    required this.token,
    required this.firstname,
    required this.surname,
  });

  factory SocialAuthRequest.fromJson(
    Map<String, dynamic> json,
    LoginMethod provider,
  ) {
    switch (provider) {
      case LoginMethod.google:
        return GoogleAuthRequest.fromJson(json);
      case LoginMethod.apple:
        return AppleAuthRequest.fromJson(json);
      case LoginMethod.facebook:
        return FacebookAuthRequest.fromJson(json);
      default:
        throw ArgumentError('Unsupported social login provider: $provider');
    }
  }

  Map<String, dynamic> toJson();
}

/// Google authentication request
class GoogleAuthRequest extends SocialAuthRequest {
  GoogleAuthRequest({
    required super.token,
    required super.firstname,
    required super.surname,
  });

  factory GoogleAuthRequest.fromJson(Map<String, dynamic> json) {
    return GoogleAuthRequest(
      token: json['token'] as String,
      firstname: json['firstname'] as String,
      surname: json['surname'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'token': token,
    'firstname': firstname,
    'surname': surname,
  };
}

/// Apple authentication request
class AppleAuthRequest extends SocialAuthRequest {
  AppleAuthRequest({
    required super.token,
    required super.firstname,
    required super.surname,
  });

  factory AppleAuthRequest.fromJson(Map<String, dynamic> json) {
    return AppleAuthRequest(
      token: json['token'] as String,
      firstname: json['firstname'] as String,
      surname: json['surname'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'token': token,
    'firstname': firstname,
    'surname': surname,
  };
}

/// Facebook authentication request with additional facebook_id and email fields
class FacebookAuthRequest extends SocialAuthRequest {
  FacebookAuthRequest({
    required super.token,
    required super.firstname,
    required super.surname,
  });

  factory FacebookAuthRequest.fromJson(Map<String, dynamic> json) {
    return FacebookAuthRequest(
      token: json['token'] as String,
      firstname: json['firstname'] as String,
      surname: json['surname'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'token': token,
    'firstname': firstname,
    'surname': surname,
  };
}
