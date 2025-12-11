/// Response model for POST /api/ebook-codes/burn_code/
/// Returns success status when code is activated
class BurnCodeResponse {
  final String result;

  BurnCodeResponse({required this.result});

  factory BurnCodeResponse.fromJson(Map<String, dynamic> json) {
    return BurnCodeResponse(result: json['result'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'result': result};
  }

  /// Check if the burn was successful
  bool get isSuccess => result == 'ok';
}
