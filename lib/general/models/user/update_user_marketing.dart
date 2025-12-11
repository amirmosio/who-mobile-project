/// Request model for updating user address
/// Used for PATCH /users/{id}/ endpoint
class UpdateUserMarketingRequest {
  final bool? marketingAccepted;

  const UpdateUserMarketingRequest({this.marketingAccepted});

  factory UpdateUserMarketingRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserMarketingRequest(
      marketingAccepted: json['accepted_marketing'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (marketingAccepted != null) {
      json['accepted_marketing'] = marketingAccepted;
    }

    return json;
  }
}
