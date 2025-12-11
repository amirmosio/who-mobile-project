import 'package:who_mobile_project/general/models/user/simple_user_model.dart';

class LoginResponse {
  String jwtToken;
  String refreshToken;
  SimpleUserModel user;

  LoginResponse({
    required this.jwtToken,
    required this.refreshToken,
    required this.user,
  });

  LoginResponse copyWith({
    String? jwtToken,
    String? refreshToken,
    SimpleUserModel? user,
  }) {
    return LoginResponse(
      jwtToken: jwtToken ?? this.jwtToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      jwtToken: json['access'] as String,
      refreshToken: json['refresh'] as String,
      user: SimpleUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'access': jwtToken,
    'refresh': refreshToken,
    'user': user.toJson(),
  };
}

class RefreshTokenResponse {
  String jwtToken;
  String refreshToken;

  RefreshTokenResponse({required this.jwtToken, required this.refreshToken});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      jwtToken: json['access'],
      refreshToken: json['refresh'],
    );
  }

  Map<String, dynamic> toJson() => {
    'access': jwtToken,
    'refresh': refreshToken,
  };
}
