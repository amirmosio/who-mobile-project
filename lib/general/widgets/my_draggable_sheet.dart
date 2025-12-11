import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import "package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart";
import 'package:who_mobile_project/ui/base_template/yr_bottom_nav_bar.dart';

class MyDraggableSheet extends StatefulWidget {
  final Widget child;
  final String title;
  final double maxHeightRatio;
  final double minHeightRatio;
  final double initialHeightRatio;
  final bool adaptToContentSize;
  final double padding;
  final double horizontalPadding;

  const MyDraggableSheet({
    super.key,
    required this.child,
    required this.title,
    this.maxHeightRatio = 0.9,
    this.minHeightRatio = 0.3,
    this.initialHeightRatio = 0.5,
    this.adaptToContentSize = true,
    this.padding = 15.0,
    this.horizontalPadding = 30.0,
  });

  @override
  State<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  static const double minSize = 0;
  final DraggableScrollableController controller =
      DraggableScrollableController();
  final GlobalKey _contentKey = GlobalKey();
  double? _adaptedInitialSize;
  double? _adaptedMaxSize;
  bool _isMeasuring = false;

  @override
  void initState() {
    controller.addListener(listenForCloseSize);
    super.initState();
    if (widget.adaptToContentSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateAdaptedSize();
      });
    }
  }

  @override
  void didUpdateWidget(MyDraggableSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.adaptToContentSize && !_isMeasuring) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateAdaptedSize();
      });
    }
  }

  void _calculateAdaptedSize() {
    if (_isMeasuring) return;
    _isMeasuring = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? contentRenderBox =
          _contentKey.currentContext?.findRenderObject() as RenderBox?;

      if (contentRenderBox != null && mounted) {
        final screenHeight = MediaQuery.of(context).size.height;
        final contentHeight = contentRenderBox.size.height;

        final totalNeededHeight =
            contentHeight +
            widget.padding +
            MediaQuery.of(context).padding.bottom +
            YRBottomNavBar.bottomNavBarHeight +
            10; // Extra buffer

        final calculatedRatio = (totalNeededHeight / screenHeight).clamp(
          widget.minHeightRatio,
          widget.maxHeightRatio,
        );

        final shouldUpdate =
            calculatedRatio != _adaptedInitialSize ||
            (calculatedRatio < (widget.maxHeightRatio) &&
                _adaptedMaxSize != calculatedRatio);

        if (shouldUpdate) {
          setState(() {
            _adaptedInitialSize = calculatedRatio;
            if (calculatedRatio < (widget.maxHeightRatio)) {
              _adaptedMaxSize = calculatedRatio;
            } else {
              _adaptedMaxSize = widget.maxHeightRatio;
            }
          });

          if (controller.isAttached) {
            controller.animateTo(
              calculatedRatio,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      }
      _isMeasuring = false;
    });
  }

  void listenForCloseSize() {
    if (controller.size <= minSize + .05) {
      Navigator.pop(context);
      controller.removeListener(listenForCloseSize);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialSize = _adaptedInitialSize ?? widget.initialHeightRatio;
    final maxSize = _adaptedMaxSize ?? widget.maxHeightRatio;

    final snapSizes = <double>{minSize, initialSize, maxSize}.toList()..sort();

    return GestureDetector(
      onPanEnd: (details) {
        context.pop();
      },
      child: Container(
        color: GVColors.transparent,
        child: DraggableScrollableSheet(
          initialChildSize: initialSize,
          minChildSize: minSize,
          maxChildSize: maxSize,
          snap: true,
          snapSizes: snapSizes,
          controller: controller,
          shouldCloseOnMinExtent: true,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: GVColors.lightGreyBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: widget.padding),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.horizontalPadding,
                        ),
                        child: _ContentMeasurer(
                          key: _contentKey,
                          onSizeChanged: () {
                            if (!_isMeasuring) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _calculateAdaptedSize();
                              });
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      style: AppTextStyles.headingH2,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    icon: const Icon(Icons.close, size: 30),
                                  ),
                                ],
                              ),
                              widget.child,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ContentMeasurer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSizeChanged;

  const _ContentMeasurer({super.key, required this.child, this.onSizeChanged});

  @override
  State<_ContentMeasurer> createState() => _ContentMeasurerState();
}

class _ContentMeasurerState extends State<_ContentMeasurer> {
  Size? _previousSize;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null && mounted) {
            final newSize = renderBox.size;
            if (_previousSize != newSize) {
              _previousSize = newSize;
              widget.onSizeChanged?.call();
            }
          }
        });
        return true;
      },
      child: SizeChangedLayoutNotifier(child: widget.child),
    );
  }
}
