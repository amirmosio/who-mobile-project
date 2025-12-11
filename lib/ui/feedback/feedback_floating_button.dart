import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/general/widgets/feedback_dialog.dart';

class FeedbackFloatingButton extends StatefulWidget {
  /// Initial position from the right edge of the screen
  final double? right;

  /// Initial position from the top edge of the screen
  final double? top;

  /// Initial position from the bottom edge of the screen
  final double? bottom;

  /// Initial position from the left edge of the screen
  final double? left;

  /// GlobalKey to RepaintBoundary for screenshot capture
  /// Pass this to enable screenshot functionality in feedback
  final GlobalKey? screenKey;

  const FeedbackFloatingButton({
    super.key,
    this.right,
    this.top,
    this.bottom,
    this.left,
    this.screenKey,
  });

  @override
  State<FeedbackFloatingButton> createState() => _FeedbackFloatingButtonState();
}

class _FeedbackFloatingButtonState extends State<FeedbackFloatingButton> {
  late double _x;
  late double _y;
  bool _showingDialog = false;

  @override
  void initState() {
    super.initState();
    // Initialize position - we'll update this in didChangeDependencies when we have screen size
    _x = 0;
    _y = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenSize = MediaQuery.of(context).size;

    // Set initial position based on provided parameters or defaults
    if (widget.right != null) {
      _x = screenSize.width - widget.right! - 48; // 48 is button width
    } else if (widget.left != null) {
      _x = widget.left!;
    } else {
      _x = screenSize.width - 16 - 48; // Default right: 16
    }

    if (widget.top != null) {
      _y = widget.top!;
    } else if (widget.bottom != null) {
      _y = screenSize.height - widget.bottom! - 48; // 48 is button height
    } else {
      _y = screenSize.height - 100 - 48; // Default bottom: 100
    }
  }

  void _showFeedbackDialog() {
    setState(() {
      _showingDialog = true;
    });
  }

  void _closeFeedbackDialog() {
    setState(() {
      _showingDialog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Floating button
        Positioned(
          left: _x,
          top: _y,
          child: GestureDetector(
            onPanStart: (details) {
              // Optional: Add haptic feedback when drag starts
            },
            onPanUpdate: (details) {
              setState(() {
                // Update position during drag, ensuring it stays within screen bounds
                _x = (_x + details.delta.dx).clamp(0, screenSize.width - 48);
                _y = (_y + details.delta.dy).clamp(0, screenSize.height - 48);
              });
            },
            onPanEnd: (details) {
              setState(() {
                // Snap to edges for better UX
                const snapDistance = 20;
                if (_x < snapDistance) {
                  _x = 16; // Snap to left edge with padding
                } else if (_x > screenSize.width - 48 - snapDistance) {
                  _x =
                      screenSize.width -
                      16 -
                      48; // Snap to right edge with padding
                }
              });
            },
            child: _buildButton(),
          ),
        ),
        // Feedback dialog overlay (when showing)
        if (_showingDialog)
          Positioned.fill(
            child: Material(
              color: Colors.black54, // Semi-transparent background
              child: GestureDetector(
                onTap: _closeFeedbackDialog, // Dismiss on background tap
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, // Prevent dismissal when tapping on dialog
                    child: FeedbackDialog(
                      onClose: _closeFeedbackDialog,
                      screenKey: widget.screenKey,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildButton() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(24),
      color: GVColors.guidaEvaiOrange,
      child: InkWell(
        onTap: _showFeedbackDialog,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: GVColors.guidaEvaiOrange.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(Icons.feedback_outlined, color: GVColors.white, size: 22),
        ),
      ),
    );
  }
}

/// Extended version with text label for better accessibility
class FeedbackFloatingButtonWithLabel extends StatelessWidget {
  /// Position from the right edge of the screen
  final double? right;

  /// Position from the top edge of the screen
  final double? top;

  /// Position from the bottom edge of the screen
  final double? bottom;

  /// Position from the left edge of the screen
  final double? left;

  /// GlobalKey to RepaintBoundary for screenshot capture
  final GlobalKey? screenKey;

  const FeedbackFloatingButtonWithLabel({
    super.key,
    this.right,
    this.top,
    this.bottom,
    this.left,
    this.screenKey,
  });

  void _showFeedbackDialog(BuildContext context) {
    // Note: This widget is not currently used, but keeping for potential future use
    // For now, just show a simple message since it doesn't have state management
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback feature available in main button'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right ?? 16,
      top: top,
      bottom: bottom ?? 100,
      left: left,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(28),
        color: GVColors.guidaEvaiOrange,
        child: InkWell(
          onTap: () => _showFeedbackDialog(context),
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: GVColors.guidaEvaiOrange.withValues(alpha: 0.3 * 255),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.feedback_outlined, color: GVColors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
