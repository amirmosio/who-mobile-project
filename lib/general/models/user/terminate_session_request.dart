class SessionIdModel {
  final String sessionId;

  SessionIdModel({required this.sessionId});

  factory SessionIdModel.fromJson(Map<String, dynamic> json) {
    return SessionIdModel(sessionId: json['session_id'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'session_id': sessionId};
  }
}
