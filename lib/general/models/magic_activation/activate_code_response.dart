/// Response model for POST /activation/neith-codes/activate-code/
/// Returns the result of subscription activation
///
/// Response codes:
/// - 200: Code activated (or already active for the same user)
/// - 400: Invalid payload
/// - 401: Code already used by another user or upselling not allowed
/// - 404: User or code not found
/// - 409: Valid code but not bound to the user phone
/// - 412: Code has no phone bound
class ActivateCodeResponse {
  final bool success;
  final String? message;
  final DateTime? subscriptionExpiresAt;
  final Map<String, dynamic>? additionalData;

  ActivateCodeResponse({
    required this.success,
    this.message,
    this.subscriptionExpiresAt,
    this.additionalData,
  });

  factory ActivateCodeResponse.fromJson(Map<String, dynamic> json) {
    // The API returns a dynamic response object
    // Extract known fields and store the rest as additionalData
    final knownKeys = {'success', 'message', 'subscription_expires_at'};
    final additional = Map<String, dynamic>.from(json)
      ..removeWhere((key, _) => knownKeys.contains(key));

    return ActivateCodeResponse(
      // If we got a 200 response, consider it success even if field is missing
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      subscriptionExpiresAt: json['subscription_expires_at'] != null
          ? DateTime.tryParse(json['subscription_expires_at'] as String)
          : null,
      additionalData: additional.isNotEmpty ? additional : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (subscriptionExpiresAt != null)
        'subscription_expires_at': subscriptionExpiresAt!.toIso8601String(),
      if (additionalData != null) ...additionalData!,
    };
  }
}
