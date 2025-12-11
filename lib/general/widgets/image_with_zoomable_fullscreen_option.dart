import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/general/extensions/string_extensions.dart';
import 'package:who_mobile_project/general/widgets/zoomable_image_viewer.dart';

/// A widget that displays an image with tap-to-zoom functionality.
///
/// When tapped, the image opens in a zoomable full-screen dialog.
/// Useful for displaying quiz questions, theory images, or any content
/// where users might need to see details more clearly.
class ImageWithZoomableFullscreenOption extends StatelessWidget {
  /// The URL of the image to display
  final String imageUrl;

  /// The width of the image container
  final double? width;

  /// The height of the image container
  final double? height;

  /// How the image should be inscribed into the box
  final BoxFit fit;

  /// The border radius of the image container
  final double borderRadius;

  /// Optional hero tag for hero animations
  final String? heroTag;

  /// Padding around the image
  final EdgeInsetsGeometry? padding;

  const ImageWithZoomableFullscreenOption({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius = 8.0,
    this.heroTag,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final widget = GestureDetector(
      onTap: () {
        showZoomableImage(
          context: context,
          imageUrl: imageUrl.addDomainIfNeeded,
          heroTag: heroTag,
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          imageUrl.addDomainIfNeeded,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: GVColors.greyFieldBackground,
              child: Icon(
                Icons.image_not_supported,
                color: GVColors.darkGreyText,
                size: (width != null && height != null)
                    ? (width! < height! ? width! : height!) * 0.3
                    : 32,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: GVColors.guidaEvaiOrange,
                strokeWidth: 2,
              ),
            );
          },
        ),
      ),
    );

    if (padding != null) {
      return Padding(padding: padding!, child: widget);
    }

    return widget;
  }
}
