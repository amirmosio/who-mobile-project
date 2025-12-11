import 'package:collection/collection.dart';
import 'package:who_mobile_project/general/constants/social_media_type.dart'
    show SocialMediaPlatformType;
import 'package:who_mobile_project/general/models/base_dropdown_item.dart';

class SocialMediaPlatform extends BaseDropDownItemModel {
  final String logoIdentifier;
  final String baseUrl;

  SocialMediaPlatformType get platformType {
    return SocialMediaPlatformType.values.singleWhereOrNull((element) {
          return element.name == logoIdentifier;
        }) ??
        SocialMediaPlatformType.other;
  }

  SocialMediaPlatform({
    required super.id,
    required super.name,
    required this.logoIdentifier,
    required this.baseUrl,
  });

  factory SocialMediaPlatform.fromJson(Map<String, dynamic> json) {
    return SocialMediaPlatform(
      id: json['value'],
      name: json['display_name'],
      logoIdentifier: json['logo_identifier'],
      baseUrl: json['base_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': id,
      'display_name': name,
      'logo_identifier': logoIdentifier,
      'base_url': baseUrl,
    };
  }
}
