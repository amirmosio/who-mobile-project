class AppReviewRequest {
  final String text;
  final String information;
  final int stars;
  final String userId;
  final int os;

  AppReviewRequest({
    required this.text,
    required this.information,
    required this.stars,
    required this.userId,
    required this.os,
  });

  factory AppReviewRequest.fromJson(Map<String, dynamic> json) {
    return AppReviewRequest(
      text: json['text'] as String,
      information: json['information'] as String,
      stars: json['stars'] as int,
      userId: json['user_id'] as String,
      os: json['os'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'information': information,
    'stars': stars,
    'user_id': userId,
    'os': os,
  };
}
