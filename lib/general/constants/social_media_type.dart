import 'package:flutter/material.dart' show IconData;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

enum SocialMediaPlatformType {
  facebook,
  instagram,
  linkedin,
  x, // Twitter/X
  snapchat,
  youtube,
  tiktok,
  other,
}

extension AvailableSocialMediaTypeDetails on SocialMediaPlatformType {
  IconData get iconData {
    switch (this) {
      case SocialMediaPlatformType.facebook:
        return FontAwesomeIcons.facebook;
      case SocialMediaPlatformType.instagram:
        return FontAwesomeIcons.instagram;
      case SocialMediaPlatformType.linkedin:
        return FontAwesomeIcons.linkedin;
      case SocialMediaPlatformType.x:
        return FontAwesomeIcons.x;
      case SocialMediaPlatformType.snapchat:
        return FontAwesomeIcons.snapchat;
      case SocialMediaPlatformType.youtube:
        return FontAwesomeIcons.youtube;
      case SocialMediaPlatformType.tiktok:
        return FontAwesomeIcons.tiktok;
      case SocialMediaPlatformType.other:
        return FontAwesomeIcons.globe;
    }
  }

  RegExp get regex {
    switch (this) {
      case SocialMediaPlatformType.facebook:
        return RegExp(r'^(?:https?:\/\/)?(?:www\.)?facebook\.com\/(.*)$');
      case SocialMediaPlatformType.instagram:
        return RegExp(r'^(?:https?:\/\/)?(?:www\.)?instagram\.com\/(.*)$');
      case SocialMediaPlatformType.linkedin:
        return RegExp(r'^(?:https?:\/\/)?(?:www\.)?linkedin\.com\/in\/(.*)$');
      case SocialMediaPlatformType.x:
        return RegExp(r'^(?:https?:\/\/)?(?:www\.)?x\.com\/(.*)$');
      case SocialMediaPlatformType.snapchat:
        return RegExp(r'^(?:https?:\/\/)?(?:www\.)?snapchat\.com\/(.*)$');
      case SocialMediaPlatformType.youtube:
        return RegExp(r'^(?:https?:\/\/)?(?:www\.)?youtube\.com\/(.*)$');
      case SocialMediaPlatformType.tiktok:
        return RegExp(r'^(?:https?:\/\/)?(?:www\.)?tiktok\.com\/@(.*)$');
      case SocialMediaPlatformType.other:
        return RegExp(r'^(?:https?:\/\/)?(?:www\.)?(.*)$');
    }
  }
}
