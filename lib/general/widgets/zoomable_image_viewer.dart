import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/general/utils/orientation_manager.dart';

/// A widget that displays a single image in a zoomable full-screen view.
class ZoomableImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;

  const ZoomableImageViewer({super.key, required this.imageUrl, this.heroTag});

  @override
  State<ZoomableImageViewer> createState() => _ZoomableImageViewerState();
}

class _ZoomableImageViewerState extends State<ZoomableImageViewer> {
  @override
  void initState() {
    super.initState();
    // Enable all orientations for full-screen view with iOS rotation trigger
    OrientationManager.enableAllOrientations();
  }

  @override
  void dispose() {
    // Restore portrait orientation when closing full-screen
    OrientationManager.lockToPortrait();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(widget.imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            heroAttributes: widget.heroTag != null
                ? PhotoViewHeroAttributes(tag: widget.heroTag!)
                : null,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) {
              return Center(
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                            (event.expectedTotalBytes ?? 1),
                  color: GVColors.guidaEvaiOrange,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.grey[600], size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: GVColors.lightGreyBackground.withValues(alpha: 0.4),
                  ),
                  child: IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a zoomable image viewer in a dialog overlay.
///
/// Usage:
/// ```dart
/// showZoomableImage(
///   context: context,
///   imageUrl: 'https://example.com/image.jpg',
/// );
/// ```
Future<void> showZoomableImage({
  required BuildContext context,
  required String imageUrl,
  String? heroTag,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black,
    barrierDismissible: true,
    useSafeArea: false,
    builder: (context) =>
        ZoomableImageViewer(imageUrl: imageUrl, heroTag: heroTag),
  );
}
