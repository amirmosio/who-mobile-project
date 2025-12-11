import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';

/// Service for handling text-to-speech audio playback
/// Uses system TTS capabilities for playing text content
@lazySingleton
class TextToSpeechService {
  final StorageManager _storage;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  TextToSpeechService(this._storage) {
    _initialize();
  }

  static String convertLocaleToTtsLanguage(String localeCode) {
    if (localeCode.contains('-') || localeCode.contains('_')) {
      return localeCode.replaceAll('_', '-');
    }

    final languageMap = {
      'en': 'en-US',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'it': 'it-IT',
      'de': 'de-DE',
      'pt': 'pt-PT',
      'ru': 'ru-RU',
      'zh': 'zh-CN',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'ar': 'ar-SA',
      'nl': 'nl-NL',
      'pl': 'pl-PL',
      'tr': 'tr-TR',
      'sv': 'sv-SE',
      'da': 'da-DK',
      'no': 'no-NO',
      'fi': 'fi-FI',
      'el': 'el-GR',
      'cs': 'cs-CZ',
      'ro': 'ro-RO',
      'hu': 'hu-HU',
      'th': 'th-TH',
      'vi': 'vi-VN',
      'id': 'id-ID',
      'uk': 'uk-UA',
      'he': 'he-IL',
      'hi': 'hi-IN',
    };

    final normalized = localeCode.toLowerCase();
    return languageMap[normalized] ?? '$normalized-${normalized.toUpperCase()}';
  }

  Future<void> _initialize() async {
    try {
      final localeCode = _storage.getLanguageCode() ?? 'it';
      final ttsLanguage = convertLocaleToTtsLanguage(localeCode);

      await _flutterTts.setLanguage(ttsLanguage);
      debugPrint(
        '🌍 TTS initialized with language: $ttsLanguage (from locale: $localeCode)',
      );

      await _flutterTts.setSpeechRate(0.5);

      await _flutterTts.setVolume(1.0);

      await _flutterTts.setPitch(1.0);

      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        await _flutterTts.setSharedInstance(true);
        await _flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        debugPrint('🔊 TTS Started');
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        debugPrint('✅ TTS Completed');
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('❌ TTS Error: $msg');
      });

      _flutterTts.setCancelHandler(() {
        _isSpeaking = false;
        debugPrint('🛑 TTS Cancelled');
      });

      _isInitialized = true;
      debugPrint('✅ TextToSpeechService initialized');
    } catch (e) {
      debugPrint('❌ Error initializing TTS: $e');
      _isInitialized = false;
    }
  }

  Future<bool> speak(String text) async {
    if (!_isInitialized) {
      debugPrint('⚠️ TTS not initialized, attempting to initialize...');
      await _initialize();
    }

    if (text.trim().isEmpty) {
      debugPrint('⚠️ Cannot speak empty text');
      return false;
    }

    try {
      if (_isSpeaking) {
        await stop();
      }

      final result = await _flutterTts.speak(text);
      if (result == 1) {
        debugPrint(
          '🔊 Speaking: ${text.substring(0, text.length > 50 ? 50 : text.length)}...',
        );
        return true;
      } else {
        debugPrint('❌ Failed to start speaking');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error speaking text: $e');
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
      debugPrint('🛑 TTS stopped');
    } catch (e) {
      debugPrint('❌ Error stopping TTS: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _flutterTts.pause();
      debugPrint('⏸️ TTS paused');
    } catch (e) {
      debugPrint('❌ Error pausing TTS: $e');
    }
  }

  Future<void> setLanguage(String language) async {
    try {
      await _flutterTts.setLanguage(language);
      debugPrint('🌍 TTS language set to: $language');
    } catch (e) {
      debugPrint('❌ Error setting language: $e');
    }
  }

  void dispose() {
    _flutterTts.stop();
  }
}
