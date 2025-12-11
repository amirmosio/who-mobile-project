import 'package:who_mobile_project/general/constants/social_media_type.dart'
    show SocialMediaPlatformType;

class ActivitySocialLinkRequest {
  String socialTypeString;
  String handle;
  String name;
  String url;

  SocialMediaPlatformType get socialType {
    return SocialMediaPlatformType.values.firstWhere(
      (type) => type.name == socialTypeString,
      orElse: () => SocialMediaPlatformType.other,
    );
  }

  ActivitySocialLinkRequest({
    required this.socialTypeString,
    required this.handle,
    required this.name,
    required this.url,
  });

  factory ActivitySocialLinkRequest.fromJson(Map<String, dynamic> json) {
    return ActivitySocialLinkRequest(
      socialTypeString: json['social_type'] ?? '',
      handle: json['handle'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    var results = {'social_type': socialTypeString, 'url': url};
    if (socialType == SocialMediaPlatformType.other) {
      results["name"] = name;
      results["handle"] = "";
    } else {
      results["name"] = "";
      results["handle"] = handle;
    }

    return results;
  }

  bool equal(ActivitySocialLinkRequest other) {
    return socialTypeString == other.socialTypeString &&
        handle == other.handle &&
        name == other.name &&
        url == other.url;
  }
}
