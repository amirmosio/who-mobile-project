/// Request model for POST /activation/neith-codes/activate-code/
/// Used to activate subscription with the magic activation code
class ActivateCodeRequest {
  final int userId;
  final String code;

  ActivateCodeRequest({required this.userId, required this.code});

  factory ActivateCodeRequest.fromJson(Map<String, dynamic> json) {
    return ActivateCodeRequest(
      userId: json['user_id'] as int,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'code': code};
  }
}
