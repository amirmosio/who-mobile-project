import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/constants/available_languages.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';

part 'app_locale_provider.g.dart';

/// Provider for managing the app's locale/language
/// Persists language preference to local storage
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  late final StorageManager _storageManager;

  @override
  Locale build() {
    _storageManager = GetIt.instance<StorageManager>();

    // Load saved language code from storage
    final savedCode = _storageManager.getLanguageCode();

    if (savedCode != null) {
      final language = AvailableLanguage.fromCode(savedCode);
      return language.locale;
    }

    // Default to Italian
    return AvailableLanguage.italian.locale;
  }

  /// Change the app's locale
  /// Persists the selection to local storage
  Future<void> setLocale(AvailableLanguage language) async {
    await _storageManager.setLanguageCode(language.code);
    state = language.locale;
  }

  /// Get the current AvailableLanguage enum value
  AvailableLanguage get currentLanguage {
    return AvailableLanguage.fromLocale(state);
  }
}
