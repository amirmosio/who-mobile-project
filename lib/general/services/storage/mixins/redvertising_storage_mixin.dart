import 'dart:convert';
import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for Redvertising advertisement storage operations
/// Matches iOS: UserDefaults.redvertisingSeenDictionary
mixin RedvertisingStorageMixin on BaseStorage {
  // Storage keys
  static const _redvertisingViewCountsKey = 'redvertising_view_counts';

  /// Get view counts for all campaigns
  /// Returns a map of campaign ID to view count
  /// Matches iOS: UserDefaults.redvertisingSeenDictionary
  Map<int, int> getRedvertisingViewCounts() {
    try {
      final jsonString = sharedPreferences.getString(
        _redvertisingViewCountsKey,
      );
      if (jsonString == null) return {};

      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map(
        (key, value) => MapEntry(int.parse(key), value as int),
      );
    } catch (error) {
      // Return empty map on error instead of throwing
      return {};
    }
  }

  /// Set view counts for all campaigns
  /// Matches iOS: UserDefaults.redvertisingSeenDictionary setter
  Future<void> setRedvertisingViewCounts(Map<int, int> viewCounts) async {
    final jsonMap = viewCounts.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await sharedPreferences.setString(
      _redvertisingViewCountsKey,
      jsonEncode(jsonMap),
    );
  }

  /// Increment view count for a specific campaign
  /// Matches iOS: UserDefaults.incrementRedvertisingSeen(advertisingID:)
  Future<void> incrementRedvertisingViewCount(int campaignId) async {
    final viewCounts = getRedvertisingViewCounts();
    viewCounts[campaignId] = (viewCounts[campaignId] ?? 0) + 1;
    await setRedvertisingViewCounts(viewCounts);
  }

  /// Get view count for a specific campaign
  /// Returns 0 if campaign has not been viewed
  int getRedvertisingViewCount(int campaignId) {
    final viewCounts = getRedvertisingViewCounts();
    return viewCounts[campaignId] ?? 0;
  }

  /// Clear all redvertising view counts
  /// Useful for testing or resetting ad state
  Future<void> clearRedvertisingViewCounts() async {
    await sharedPreferences.remove(_redvertisingViewCountsKey);
  }
}
