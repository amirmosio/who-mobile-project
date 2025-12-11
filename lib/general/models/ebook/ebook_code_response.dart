/// Response model for GET /api/ebook-codes/get_code/
/// Returns the user's ebook code if they have one
class EbookCodeResponse {
  final String code;

  EbookCodeResponse({required this.code});

  factory EbookCodeResponse.fromJson(Map<String, dynamic> json) {
    return EbookCodeResponse(code: json['code'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'code': code};
  }
}
