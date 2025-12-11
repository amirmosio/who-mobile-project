import 'package:who_mobile_project/general/constants/social_media_type.dart';

class SocialMediaUtils {
  SocialMediaUtils._privateConstructor();

  static String usernameExtractor(String link) {
    MapEntry<SocialMediaPlatformType, RegExp>? entry = detect(link);
    if (entry != null) {
      final match = entry.value.firstMatch(link);
      if (match != null && match.groupCount >= 2) {
        return match.group(2) ?? link; // the username
      }
    }
    return link;
  }

  static MapEntry<SocialMediaPlatformType, RegExp>? detect(String url) {
    for (final entry in SocialMediaPlatformType.values.map(
      (e) => MapEntry(e, e.regex),
    )) {
      if (entry.value.hasMatch(url)) {
        return entry;
      }
    }
    return null;
  }

  static String? extractUsername(String url) {
    final platformRegexMap = detect(url);
    if (platformRegexMap == null) return null;

    final match = platformRegexMap.value.firstMatch(url);
    if (match != null) {
      return match.group(match.groupCount); // last group = username
    }
    return null;
  }
}
