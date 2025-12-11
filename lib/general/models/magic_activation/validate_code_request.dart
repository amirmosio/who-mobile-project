/// Request model for POST /activation/neith-codes/validate-code/
/// Used to validate a magic activation code
class ValidateCodeRequest {
  final String code;

  ValidateCodeRequest({required this.code});

  factory ValidateCodeRequest.fromJson(Map<String, dynamic> json) {
    return ValidateCodeRequest(code: json['code'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'code': code};
  }
}
