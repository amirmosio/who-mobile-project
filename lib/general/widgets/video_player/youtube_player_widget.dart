import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubePlayerWidget extends ConsumerStatefulWidget {
  final String videoId;
  final bool autoPlay;

  const YouTubePlayerWidget({
    super.key,
    required this.videoId,
    this.autoPlay = false,
  });

  @override
  ConsumerState<YouTubePlayerWidget> createState() =>
      _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends ConsumerState<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    // Validate video ID
    if (widget.videoId.isEmpty) {
      if (kDebugMode) {
        debugPrint('❌ YouTubePlayerWidget: Empty video ID provided');
      }
      return;
    }

    // YouTube video IDs should be 11 characters
    if (widget.videoId.length != 11) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ YouTubePlayerWidget: Invalid video ID length. Expected 11 characters, got ${widget.videoId.length}. Video ID: ${widget.videoId}',
        );
      }
    }

    try {
      // TODO: Removed - appPreferencesProvider no longer available
      // Default to Italian language
      const appLanguageCode = 'it';

      // Initialize controller without video first, then load video
      // This ensures the WebView is fully ready before loading content
      _controller = YoutubePlayerController(
        params: YoutubePlayerParams(
          mute: false,
          showControls: true,
          showFullscreenButton: true, // Let YouTube handle fullscreen natively
          enableCaption: true,
          captionLanguage:
              appLanguageCode, // Prefer caption language matching app language
          interfaceLanguage:
              appLanguageCode, // Set player UI language and audio preference
          // Note: interfaceLanguage tells YouTube to prefer audio in this language if available,
          // otherwise it falls back to the video's original audio
          loop: false,
          enableJavaScript: true,
          playsInline: false, // false = allows native fullscreen behavior
          strictRelatedVideos: true,
          // Explicitly set origin to YouTube to avoid embedding restrictions
          origin: 'https://www.youtube-nocookie.com',
        ),
      );

      // Load video after a short delay to ensure WebView is initialized
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          // Use cueVideoById to load without autoplay, or loadVideoById to autoplay
          if (widget.autoPlay) {
            _controller.loadVideoById(videoId: widget.videoId);
          } else {
            _controller.cueVideoById(videoId: widget.videoId);
          }
        }
      });

      // Listen to player state changes and errors
      _controller.stream.listen(
        (value) {
          if (kDebugMode && value.error != YoutubeError.none) {
            debugPrint('❌ YouTubePlayerWidget: ERROR DETECTED: ${value.error}');
            debugPrint('   Error details: ${value.toString()}');
          }

          // Don't retry if video cannot be embedded (permanent restriction)
          final isEmbeddingError =
              value.error == YoutubeError.sameAsNotEmbeddable ||
              value.error == YoutubeError.videoNotFound ||
              value.error == YoutubeError.notEmbeddable;

          // Try to reload video if we get a transient error and player is not ready
          if ((value.error == YoutubeError.invalidParam ||
                  value.error == YoutubeError.unknown) &&
              value.metaData.videoId.isEmpty &&
              (value.playerState == PlayerState.unStarted ||
                  value.playerState == PlayerState.unknown) &&
              _retryCount < _maxRetries &&
              !isEmbeddingError) {
            _retryCount++;
            if (kDebugMode) {
              debugPrint(
                '🔄 YouTubePlayerWidget: Retrying video load (attempt $_retryCount/$_maxRetries)',
              );
            }
            // Wait progressively longer for each retry
            final delay = Duration(milliseconds: 500 * _retryCount);
            Future.delayed(delay, () async {
              try {
                if (mounted) {
                  // Use cueVideoById to load without autoplay, or loadVideoById to autoplay
                  if (widget.autoPlay) {
                    await _controller.loadVideoById(videoId: widget.videoId);
                  } else {
                    await _controller.cueVideoById(videoId: widget.videoId);
                  }
                  if (mounted) {
                    setState(() {
                      _retryCount = 0; // Reset on success
                    });
                  }
                }
              } catch (e) {
                if (kDebugMode) {
                  debugPrint(
                    '❌ YouTubePlayerWidget: Error reloading video: $e',
                  );
                }
                if (_retryCount >= _maxRetries) {
                  if (kDebugMode) {
                    debugPrint(
                      '❌ YouTubePlayerWidget: Max retries reached. Giving up.',
                    );
                  }
                }
              }
            });
          } else if (value.metaData.videoId.isNotEmpty &&
              value.error == YoutubeError.none) {
            // Reset retry count on success
            if (_retryCount > 0 && mounted) {
              setState(() {
                _retryCount = 0;
              });
            }
          }

          if (value.error != YoutubeError.none) {
            if (kDebugMode) {
              debugPrint('❌ YouTubePlayerWidget: Player error detected');
              debugPrint('   Error type: ${value.error}');
              debugPrint('   Error name: ${value.error.name}');
              debugPrint('   Error index: ${value.error.index}');
              debugPrint('   Video ID: ${widget.videoId}');
              debugPrint('   Metadata video ID: ${value.metaData.videoId}');
              debugPrint('   Player state: ${value.playerState}');
              debugPrint('   All YoutubeError values:');
              for (var err in YoutubeError.values) {
                debugPrint('     - ${err.name} (${err.index})');
              }
            }
          }
        },
        onError: (error, stackTrace) {
          if (kDebugMode) {
            debugPrint('❌ YouTubePlayerWidget: Stream error');
            debugPrint('   Error: $error');
            debugPrint('   Stack trace: $stackTrace');
          }
        },
        cancelOnError: false,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ YouTubePlayerWidget: Exception during initialization');
        debugPrint('   Error: $e');
        debugPrint('   Stack trace: $stackTrace');
      }
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void deactivate() {
    // Prevent unintended playback when this widget is navigated away from
    if (mounted) {
      _controller.pauseVideo();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(controller: _controller),
            ),
            // Error overlay only
            YoutubeValueBuilder(
              controller: _controller,
              builder: (context, value) {
                if (value.error != YoutubeError.none) {
                  if (kDebugMode) {
                    debugPrint(
                      '🚨 YouTubePlayerWidget: Displaying error overlay - ${value.error}',
                    );
                  }

                  return Positioned.fill(
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _getErrorMessage(value.error),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (value.error ==
                                        YoutubeError.sameAsNotEmbeddable ||
                                    value.error ==
                                        YoutubeError.notEmbeddable) ...[
                                  const SizedBox(height: 8),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32,
                                    ),
                                    child: Text(
                                      'The video owner has disabled playback in embedded players. Please choose a different video.',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                                if (kDebugMode) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Error: ${value.error}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Video ID: ${widget.videoId}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Metadata Video ID: ${value.metaData.videoId.isEmpty ? "Empty" : value.metaData.videoId}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Player State: ${value.playerState}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Is Ready: ${value.metaData.videoId.isNotEmpty}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(YoutubeError error) {
    switch (error) {
      case YoutubeError.sameAsNotEmbeddable:
      case YoutubeError.notEmbeddable:
        return 'Video cannot be embedded';
      case YoutubeError.videoNotFound:
      case YoutubeError.cannotFindVideo:
        return 'Video not found';
      case YoutubeError.invalidParam:
        return 'Invalid video parameter';
      case YoutubeError.html5Error:
        return 'HTML5 player error';
      case YoutubeError.unknown:
        return 'Unknown error occurred';
      case YoutubeError.none:
        return 'No error';
    }
  }
}
