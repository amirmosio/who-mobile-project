class TokenExchangeRequest {
  final String legacyToken;

  TokenExchangeRequest({required this.legacyToken});

  factory TokenExchangeRequest.fromJson(Map<String, dynamic> json) {
    return TokenExchangeRequest(legacyToken: json['legacy_token'] as String);
  }

  Map<String, dynamic> toJson() => {'legacy_token': legacyToken};
}
