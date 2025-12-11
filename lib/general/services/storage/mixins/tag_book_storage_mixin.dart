import 'dart:convert';

import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for tag book QR code cache storage operations
mixin TagBookStorageMixin on BaseStorage {
  static const _tagBookQrCacheKey = "tag_book_qr_cache";

  /// Save QR codes cache (page number -> list of QR code values)
  Future<void> setTagBookQrCache(Map<int, List<String>> cache) async {
    final jsonData = <String, dynamic>{};
    cache.forEach((key, value) {
      jsonData[key.toString()] = value;
    });
    await sharedPreferences.setString(_tagBookQrCacheKey, jsonEncode(jsonData));
  }

  /// Get QR codes cache
  Map<int, List<String>>? getTagBookQrCache() {
    final jsonString = sharedPreferences.getString(_tagBookQrCacheKey);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final results = <int, List<String>>{};
      jsonData.forEach((key, value) {
        results[int.parse(key)] = List<String>.from(value);
      });
      return results;
    } catch (_) {
      return null;
    }
  }
}
