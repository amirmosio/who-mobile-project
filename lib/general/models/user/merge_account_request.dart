import 'package:who_mobile_project/general/constants/login_methods.dart';

/// Request model for merging accounts
/// Supports both credentials (email/password) and oauth authentication (Apple/Google/Facebook)
class MergeAccountRequest {
  final MergeFromCredentials? mergeFrom;

  MergeAccountRequest({this.mergeFrom});

  factory MergeAccountRequest.fromCredentials({
    required String username,
    required String password,
  }) {
    return MergeAccountRequest(
      mergeFrom: MergeFromCredentials(
        provider: LoginMethod.email,
        username: username,
        password: password,
      ),
    );
  }

  factory MergeAccountRequest.fromSocial({
    required String token,
    required String firstname,
    required String surname,
    required LoginMethod provider,
    String? facebookId,
    String? email,
  }) {
    return MergeAccountRequest(
      mergeFrom: MergeFromCredentials(
        provider: provider,
        token: token,
        firstname: firstname,
        surname: surname,
        facebookId: facebookId,
        email: email,
      ),
    );
  }

  factory MergeAccountRequest.fromJson(Map<String, dynamic> json) {
    return MergeAccountRequest(
      mergeFrom: json['merge_from'] != null
          ? MergeFromCredentials.fromJson(
              json['merge_from'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'merge_from': mergeFrom?.toJson()};
  }
}

class MergeFromCredentials {
  final LoginMethod provider;
  final String? username;
  final String? password;
  final String? token;
  final String? firstname;
  final String? surname;
  final String? facebookId;
  final String? email;

  MergeFromCredentials({
    required this.provider,
    this.username,
    this.password,
    this.token,
    this.firstname,
    this.surname,
    this.facebookId,
    this.email,
  });

  factory MergeFromCredentials.fromJson(Map<String, dynamic> json) {
    final provider = json['provider'] != null
        ? LoginMethod.fromId(json['provider'] as String)
        : LoginMethod.email;

    return MergeFromCredentials(
      provider: provider,
      username: json['username'] as String?,
      password: json['password'] as String?,
      token: json['token'] as String?,
      firstname: json['firstname'] as String?,
      surname: json['surname'] as String?,
      facebookId: json['facebook_id'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'type': provider.mergeAccountType};

    if (provider.isEmailLogin) {
      map['username'] = username;
      map['password'] = password;
    } else if (provider.isSocialLogin) {
      map['token'] = token;
      map['firstname'] = firstname;
      map['surname'] = surname;
      map['provider'] = provider.id;

      // Add Facebook-specific fields if provider is Facebook
      if (provider == LoginMethod.facebook) {
        map['facebook_id'] = facebookId;
        map['email'] = email;
      }
    }

    return map;
  }
}
