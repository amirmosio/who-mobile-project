import 'package:flutter/material.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VimeoPlayerWidget extends StatefulWidget {
  final String videoId;

  const VimeoPlayerWidget({super.key, required this.videoId});

  @override
  State<VimeoPlayerWidget> createState() => _VimeoPlayerWidgetState();
}

class _VimeoPlayerWidgetState extends State<VimeoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return VimeoVideoPlayer(
      videoId: widget.videoId,
      isAutoPlay: false,
      isLooping: false,
      isMuted: false,
      showTitle: false,
      showByline: false,
      showControls: true,
      enableDNT: true,
      backgroundColor: Colors.black,
      onReady: () {},
      onPlay: () {},
      onPause: () {},
      onFinish: () {},
    );
  }
}
