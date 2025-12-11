/// Response model for account merge
/// Can represent both success and error responses
class MergeAccountResponse {
  final String detail;
  final int? mergedFromUserId;
  final int? mergedIntoUserId;

  MergeAccountResponse({
    required this.detail,
    this.mergedFromUserId,
    this.mergedIntoUserId,
  });

  /// Returns true if this is a successful merge response
  bool get isSuccess => mergedFromUserId != null && mergedIntoUserId != null;

  factory MergeAccountResponse.fromJson(Map<String, dynamic> json) {
    return MergeAccountResponse(
      detail: json['detail'] as String,
      mergedFromUserId: json['merged_from_user_id'] as int?,
      mergedIntoUserId: json['merged_into_user_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      if (mergedFromUserId != null) 'merged_from_user_id': mergedFromUserId,
      if (mergedIntoUserId != null) 'merged_into_user_id': mergedIntoUserId,
    };
  }
}
