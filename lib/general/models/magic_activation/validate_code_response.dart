/// Response model for POST /activation/neith-codes/validate-code/
/// Returns validation status for magic activation code
///
/// Response codes:
/// - 200: Valid code (may include already_used=true if used by same phone)
/// - 400: Bad request
/// - 401: Code already used by another phone
/// - 404: Code not found
/// - 409: Code is not bound to the provided phone
/// - 412: Code has no phone bound
class ValidateCodeResponse {
  final bool isValid;
  final bool alreadyUsed;
  final String? phoneNumber;
  final String? message;
  final Map<String, dynamic>? additionalData;

  ValidateCodeResponse({
    required this.isValid,
    this.alreadyUsed = false,
    this.phoneNumber,
    this.message,
    this.additionalData,
  });

  factory ValidateCodeResponse.fromJson(Map<String, dynamic> json) {
    // The API returns a dynamic response object
    // Extract known fields and store the rest as additionalData
    final knownKeys = {'is_valid', 'already_used', 'phone_number', 'message'};
    final additional = Map<String, dynamic>.from(json)
      ..removeWhere((key, _) => knownKeys.contains(key));

    return ValidateCodeResponse(
      isValid: json['is_valid'] as bool? ?? true,
      alreadyUsed: json['already_used'] as bool? ?? false,
      phoneNumber: json['phone_number'] as String?,
      message: json['message'] as String?,
      additionalData: additional.isNotEmpty ? additional : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_valid': isValid,
      'already_used': alreadyUsed,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (message != null) 'message': message,
      if (additionalData != null) ...additionalData!,
    };
  }
}
