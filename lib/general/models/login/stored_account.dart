import 'package:who_mobile_project/general/constants/login_methods.dart';

class StoredAccount {
  final String email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? avatarPath;
  final DateTime lastLoginTime;
  final LoginMethod loginMethod;

  String? get fullName {
    if ((firstName == null || firstName!.isEmpty) &&
        (lastName == null || lastName!.isEmpty)) {
      return null;
    }
    if (firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty) {
      return "$firstName $lastName";
    }
    final first = (firstName != null && firstName!.isNotEmpty)
        ? firstName!
        : "";
    final last = (lastName != null && lastName!.isNotEmpty) ? lastName! : "";
    final combined = "$first $last".trim();
    return combined.isNotEmpty ? combined : null;
  }

  String get displayName {
    final name = fullName;
    if (name == null && email.isNotEmpty) {
      final emailUser = email.split('@').first;
      return emailUser;
    }
    return name ?? "User";
  }

  String get initials {
    if (firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty) {
      return "${firstName![0].toUpperCase()}${lastName![0].toUpperCase()}";
    }
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    }
    if (lastName != null && lastName!.isNotEmpty) {
      return lastName![0].toUpperCase();
    }
    if (email.isNotEmpty) {
      return email.substring(0, 1).toUpperCase();
    }
    return "?";
  }

  StoredAccount({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.avatarPath,
    required this.lastLoginTime,
    required this.loginMethod,
  });

  StoredAccount copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? avatarPath,
    DateTime? lastLoginTime,
    LoginMethod? loginMethod,
  }) {
    return StoredAccount(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName,
      lastName: lastName,
      avatarPath: avatarPath,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
      loginMethod: loginMethod ?? this.loginMethod,
    );
  }

  factory StoredAccount.fromJson(Map<String, dynamic> json) {
    return StoredAccount(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarPath: json['avatar_path'] as String?,
      lastLoginTime: DateTime.parse(json['last_login_time'] as String),
      loginMethod: LoginMethod.fromId(json['login_method'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'first_name': firstName,
    'last_name': lastName,
    'avatar_path': avatarPath,
    'last_login_time': lastLoginTime.toIso8601String(),
    'login_method': loginMethod.id,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoredAccount &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}
