/// Response model for deepening video API
/// Matches backend DeepeningVideoViewSet.get_manual_video response
class DeepeningVideoResponse {
  final String? videoUrl;

  DeepeningVideoResponse({this.videoUrl});

  factory DeepeningVideoResponse.fromJson(Map<String, dynamic> json) {
    return DeepeningVideoResponse(videoUrl: json['video_url'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'video_url': videoUrl};
  }

  /// Check if video URL is available
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  @override
  String toString() {
    return 'DeepeningVideoResponse(videoUrl: $videoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeepeningVideoResponse && other.videoUrl == videoUrl;
  }

  @override
  int get hashCode => videoUrl.hashCode;
}
