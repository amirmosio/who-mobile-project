import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SU {
  /// Design time screen size
  /// With this set, we can easily calculate relative sizes if needed
  static const _screenWidth = 430;
  static const _screenHeight = 932;

  SU._privateConstructor();

  static double forceBetweenMinMax(double min, double max, double value) {
    if (value > max) {
      return max;
    } else if (value < min)
      // ignore: curly_braces_in_flow_control_structures
      return min;
    else
      // ignore: curly_braces_in_flow_control_structures
      return value;
  }

  static double max(double v1, double v2) {
    if (v1 > v2) {
      return v1;
    } else {
      return v2;
    }
  }

  static double min(double v1, double v2) {
    if (v1 < v2) {
      return v1;
    } else {
      return v2;
    }
  }

  static double relW(double x, BuildContext context, {double? max}) {
    double width = MediaQuery.of(context).size.width;
    double res = x * (width / _screenWidth);
    return max != null ? min(res, max) : res;
  }

  static double relRatioW(double ration, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width * ration;
  }

  static double relWR(double x, BuildContext context, {double? max}) {
    double width = MediaQuery.of(context).size.width;
    double ratio = MediaQuery.of(context).size.aspectRatio;
    double res = x * (width / _screenWidth) / ratio;
    return max != null ? min(res, max) : res;
  }

  static double relH(double y, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return y * (height / _screenHeight);
  }

  static double mediaQueryWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double mediaQueryHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Mobile sized
  static bool isMSized(BuildContext context) {
    return getDeviceType(MediaQuery.of(context).size) ==
        DeviceScreenType.mobile;
  }

  /// Check if device is a tablet (shortest side >= 600)
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide >= 600;
  }

  /// Check if device is a small phone (not tablet and height < 800)
  static bool isSmallPhone(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return !isTablet(context) && size.height < 800.0;
  }

  /// Calculate banner height based on device type, orientation, and screen size
  /// Returns a height that is clamped between min and max values based on device type
  static double calculateBannerHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final orientation = mediaQuery.orientation;

    final isTabletDevice = isTablet(context);
    final isSmallPhoneDevice = isSmallPhone(context);

    final bannerWidth = size.width;

    // Default: 16:9 hero
    double aspectRatio = 16 / 9; // width / height

    // Make it a bit wider/shorter in landscape
    if (orientation == Orientation.landscape) {
      aspectRatio = 21 / 9;
    }

    double height = bannerWidth / aspectRatio;

    // Clamp per device type
    late double minHeight;
    late double maxHeight;

    if (isTabletDevice) {
      // On tablets, keep it visually important but not dominating
      minHeight = 180.0;
      maxHeight = size.height * 0.30; // max 30% of screen height
    } else if (isSmallPhoneDevice) {
      // Really small phones
      minHeight = 80.0;
      maxHeight = 120.0;
    } else {
      // Normal phones
      minHeight = 100.0;
      maxHeight = 200.0;
    }

    return height.clamp(minHeight, maxHeight);
  }

  /// Desktop sized or table sized
  static bool isDSized(BuildContext context) {
    return getDeviceType(MediaQuery.of(context).size) !=
        DeviceScreenType.mobile;
  }

  static T? cond<T>(BuildContext context, {T? mobile, T? desktop}) {
    if (SU.isMSized(context)) return mobile;
    return desktop;
  }

  static T condH<T>(
    BuildContext context, {
    required T small,
    required T med,
    required T big,
  }) {
    double height = MediaQuery.of(context).size.height;
    if (height < 650) {
      return small;
    } else if (height < 900) {
      return med;
    } else {
      return big;
    }
  }
}
