import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/icons.dart';

enum SocialMedia { instagram, tiktok, youtube, facebook }

extension SocialMediaIcon on SocialMedia {
  Widget getIcon({Color? color}) {
    switch (this) {
      case SocialMedia.instagram:
        return Icon(YRIcons.instagram, color: color ?? BSColors.black);
      case SocialMedia.tiktok:
        return Icon(YRIcons.tiktok, color: color ?? BSColors.black);
      case SocialMedia.youtube:
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            YRIcons.youtube,
            color: color ?? BSColors.black,
            size: 17,
          ),
        );
      case SocialMedia.facebook:
        return Icon(YRIcons.facebook, color: color ?? BSColors.black);
    }
  }
}
