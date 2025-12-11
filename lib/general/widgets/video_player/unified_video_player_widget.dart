import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:who_mobile_project/general/widgets/video_player/youtube_player_widget.dart';
import 'package:who_mobile_project/general/widgets/video_player/vimeo_player_widget.dart';
import 'package:who_mobile_project/general/utils/youtube_utils.dart';

enum VideoPlatform { youtube, vimeo, unknown }

class UnifiedVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final double height;
  final bool autoPlay;

  const UnifiedVideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.height = 237,
    this.autoPlay = false,
  });

  @override
  State<UnifiedVideoPlayerWidget> createState() =>
      _UnifiedVideoPlayerWidgetState();
}

class _UnifiedVideoPlayerWidgetState extends State<UnifiedVideoPlayerWidget> {
  VideoPlatform _platform = VideoPlatform.unknown;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _parseVideoUrl();
    _initializePlayer();
  }

  void _parseVideoUrl() {
    final url = widget.videoUrl.toLowerCase();

    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      _platform = VideoPlatform.youtube;
      _videoId = YoutubeUtils.extractVideoId(widget.videoUrl);
      if (_videoId == null || _videoId!.isEmpty) {
        if (kDebugMode) {
          debugPrint(
            '❌ UnifiedVideoPlayerWidget: Failed to extract video ID from URL: ${widget.videoUrl}',
          );
        }
      }
    } else if (url.contains('vimeo.com')) {
      _platform = VideoPlatform.vimeo;
      _videoId = _extractVimeoVideoId(widget.videoUrl);
    } else {
      _platform = VideoPlatform.unknown;
      if (kDebugMode) {
        debugPrint(
          '❌ UnifiedVideoPlayerWidget: Unknown video platform - ${widget.videoUrl}',
        );
      }
    }
  }

  String? _extractVimeoVideoId(String url) {
    final regex = RegExp(
      r'(?:vimeo\.com\/|player\.vimeo\.com\/video\/)(\d+)',
      caseSensitive: false,
    );

    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  void _initializePlayer() {
    // No need for separate initialization since individual players handle it
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_platform == VideoPlatform.unknown || _videoId == null) {
      if (kDebugMode) {
        debugPrint(
          '❌ UnifiedVideoPlayerWidget: Cannot render player (platform=$_platform, videoId=$_videoId)',
        );
      }
      return _buildErrorWidget();
    }

    // For YouTube, don't constrain height - let AspectRatio widget determine it
    // For Vimeo, use fixed height
    final shouldConstrainHeight = _platform == VideoPlatform.vimeo;

    return Container(
      width: double.infinity,
      height: shouldConstrainHeight ? widget.height : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildPlayer(),
      ),
    );
  }

  Widget _buildPlayer() {
    switch (_platform) {
      case VideoPlatform.youtube:
        return YouTubePlayerWidget(
          videoId: _videoId!,
          autoPlay: widget.autoPlay,
        );

      case VideoPlatform.vimeo:
        return VimeoPlayerWidget(videoId: _videoId!);

      case VideoPlatform.unknown:
        return _buildErrorWidget();
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 48),
            SizedBox(height: 8),
            Text(
              'Unsupported video platform',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
