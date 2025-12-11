import 'package:who_mobile_project/general/models/activity_information/social_link_request.dart'
    show ActivitySocialLinkRequest;

class ActivitySocialLink extends ActivitySocialLinkRequest {
  final String id;
  final String fullUrl;
  final String displayName;
  final String logoIdentifier;

  ActivitySocialLink({
    required super.socialTypeString,
    required super.handle,
    required super.name,
    required super.url,
    required this.id,
    required this.fullUrl,
    required this.displayName,
    required this.logoIdentifier,
  });

  factory ActivitySocialLink.fromJson(Map<String, dynamic> json) {
    return ActivitySocialLink(
      socialTypeString: json['social_type'] ?? '',
      handle: json['handle'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      id: json['id'] ?? '',
      fullUrl: json['full_url'] ?? '',
      displayName: json['display_name'] ?? '',
      logoIdentifier: json['logo_identifier'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'social_type': socialTypeString,
      'handle': handle,
      'name': name,
      'url': url,
    };
  }

  ActivitySocialLink copy() {
    return ActivitySocialLink(
      socialTypeString: socialTypeString,
      handle: handle,
      name: name,
      url: url,
      id: id,
      fullUrl: fullUrl,
      displayName: displayName,
      logoIdentifier: logoIdentifier,
    );
  }
}
