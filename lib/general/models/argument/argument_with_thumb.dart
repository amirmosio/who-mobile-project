import 'package:who_mobile_project/general/database/app_database.dart';

/// Argument with its associated thumb image
/// Matches iOS Argument entity with thumb relationship
class ArgumentWithThumb {
  final ArgumentEntity argument;
  final PictureQuizEntity? thumb;

  const ArgumentWithThumb({required this.argument, this.thumb});

  /// Get the full image URL (prepending base URL if needed)
  String? get imageUrl {
    if (thumb?.image == null || thumb!.image!.isEmpty) {
      return null;
    }

    final image = thumb!.image!;
    // If image already contains full URL, return as is
    if (image.contains('http://') || image.contains('https://')) {
      return image;
    }

    // Otherwise prepend base URL (matching iOS behavior)
    const baseUrl = 'https://aulagev-17585.kxcdn.com';
    return '$baseUrl$image';
  }

  /// Get the full HD image URL (prepending base URL if needed)
  String? get imageHdUrl {
    if (thumb?.imageHd == null || thumb!.imageHd!.isEmpty) {
      return null;
    }

    final imageHd = thumb!.imageHd!;
    // If image already contains full URL, return as is
    if (imageHd.contains('http://') || imageHd.contains('https://')) {
      return imageHd;
    }

    // Otherwise prepend base URL (matching iOS behavior)
    const baseUrl = 'https://aulagev-17585.kxcdn.com';
    return '$baseUrl$imageHd';
  }
}
