import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/services/audio/text_to_speech_service.dart';

/// Reusable audio play button widget for text-to-speech functionality
///
/// This widget provides a consistent UI for playing audio across the app.
/// It shows a play/stop button that uses the TextToSpeechService to read text aloud.
/// The language is automatically determined from the user's stored language preference.
///
/// Usage:
/// ```dart
/// AudioPlayButton(
///   text: "Text to be spoken",
///   language: "it-IT", // Optional, overrides stored language if provided
/// )
/// ```
class AudioPlayButton extends ConsumerStatefulWidget {
  /// The text to be spoken when the button is pressed
  final String text;

  /// The language code for TTS (e.g., 'it-IT', 'en-US', 'es-ES', 'fr-FR')
  /// If null, uses the language stored in user preferences
  final String? language;

  /// Custom icon size, defaults to 20
  final double? iconSize;

  /// Custom button background color
  final Color? backgroundColor;

  /// Custom icon color
  final Color? iconColor;

  /// Callback when audio starts playing
  final VoidCallback? onPlayStart;

  /// Callback when audio stops playing
  final VoidCallback? onPlayStop;

  const AudioPlayButton({
    super.key,
    required this.text,
    this.language,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    this.onPlayStart,
    this.onPlayStop,
  });

  @override
  ConsumerState<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends ConsumerState<AudioPlayButton> {
  late final TextToSpeechService _ttsService;
  bool _isPlaying = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _ttsService = getIt<TextToSpeechService>();
  }

  @override
  void dispose() {
    _isDisposed = true;
    // Stop any ongoing speech when widget is disposed
    if (_isPlaying) {
      _ttsService.stop();
    }
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_isDisposed || !mounted) return;

    if (_isPlaying) {
      // Stop audio
      await _ttsService.stop();
      if (mounted && !_isDisposed) {
        setState(() {
          _isPlaying = false;
        });
        widget.onPlayStop?.call();
      }
    } else {
      // Set language if provided
      if (widget.language != null) {
        await _ttsService.setLanguage(widget.language!);
      }

      // Start audio
      final success = await _ttsService.speak(widget.text);
      if (success && mounted && !_isDisposed) {
        setState(() {
          _isPlaying = true;
        });
        widget.onPlayStart?.call();

        // Auto-reset when speech completes
        // Note: The TTS service has completion handler, but we also check periodically
        _monitorSpeechCompletion();
      }
    }
  }

  /// Monitor speech completion and update UI accordingly
  void _monitorSpeechCompletion() {
    if (_isDisposed || !mounted) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isDisposed || !mounted) return;

      if (_isPlaying && !_ttsService.isSpeaking) {
        if (mounted && !_isDisposed) {
          setState(() {
            _isPlaying = false;
          });
          widget.onPlayStop?.call();
        }
      } else if (_isPlaying) {
        // Continue monitoring only if not disposed
        _monitorSpeechCompletion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAudio,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFD9D9D9), // GVColors.borderGrey
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.stop : Icons.volume_up,
          size: widget.iconSize ?? 20,
          color: widget.iconColor ?? const Color(0xFFFF6900), // GVColors.orange
        ),
      ),
    );
  }
}

/// Compact version of AudioPlayButton with minimal styling
/// Useful for inline placement within text or compact UIs
class AudioPlayButtonCompact extends ConsumerStatefulWidget {
  /// The text to be spoken when the button is pressed
  final String text;

  /// The language code for TTS (e.g., 'it-IT', 'en-US', 'es-ES', 'fr-FR')
  final String? language;

  /// Custom icon size, defaults to 18
  final double? iconSize;

  /// Custom icon color
  final Color? iconColor;

  const AudioPlayButtonCompact({
    super.key,
    required this.text,
    this.language,
    this.iconSize,
    this.iconColor,
  });

  @override
  ConsumerState<AudioPlayButtonCompact> createState() =>
      _AudioPlayButtonCompactState();
}

class _AudioPlayButtonCompactState
    extends ConsumerState<AudioPlayButtonCompact> {
  late final TextToSpeechService _ttsService;
  bool _isPlaying = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _ttsService = getIt<TextToSpeechService>();
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (_isPlaying) {
      _ttsService.stop();
    }
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_isDisposed || !mounted) return;

    if (_isPlaying) {
      await _ttsService.stop();
      if (mounted && !_isDisposed) {
        setState(() {
          _isPlaying = false;
        });
      }
    } else {
      if (widget.language != null) {
        await _ttsService.setLanguage(widget.language!);
      }

      final success = await _ttsService.speak(widget.text);
      if (success && mounted && !_isDisposed) {
        setState(() {
          _isPlaying = true;
        });
        _monitorSpeechCompletion();
      }
    }
  }

  void _monitorSpeechCompletion() {
    if (_isDisposed || !mounted) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isDisposed || !mounted) return;

      if (_isPlaying && !_ttsService.isSpeaking) {
        if (mounted && !_isDisposed) {
          setState(() {
            _isPlaying = false;
          });
        }
      } else if (_isPlaying) {
        // Continue monitoring only if not disposed
        _monitorSpeechCompletion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleAudio,
      icon: Icon(
        _isPlaying ? Icons.stop : Icons.volume_up,
        size: widget.iconSize ?? 18,
        color: widget.iconColor ?? const Color(0xFFFF6900), // GVColors.orange
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
