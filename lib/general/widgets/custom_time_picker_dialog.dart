import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onTimeChanged;

  const CustomTimePickerDialog({
    super.key,
    this.initialTime,
    this.onTimeChanged,
  });

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late TimeOfDay _selectedTime;
  late bool _isAM;
  bool _isSelectingHour = true;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? const TimeOfDay(hour: 15, minute: 30);
    _isAM = _selectedTime.period == DayPeriod.am;
  }

  void _onHourChanged(int hour) {
    int newHour = hour;
    if (!_isAM && hour != 12) {
      newHour = hour + 12;
    } else if (_isAM && hour == 12) {
      newHour = 0;
    }

    setState(() {
      _selectedTime = TimeOfDay(hour: newHour, minute: _selectedTime.minute);
      _isSelectingHour = false;
    });
  }

  void _onMinuteChanged(int minute) {
    setState(() {
      _selectedTime = TimeOfDay(hour: _selectedTime.hour, minute: minute);
    });
  }

  void _togglePeriod(bool isAM) {
    setState(() {
      _isAM = isAM;
      int newHour = _selectedTime.hour;

      if (isAM && _selectedTime.hour >= 12) {
        newHour = _selectedTime.hour - 12;
      } else if (!isAM && _selectedTime.hour < 12) {
        newHour = _selectedTime.hour + 12;
      }

      _selectedTime = TimeOfDay(hour: newHour, minute: _selectedTime.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: GVColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        width: 320,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    l10n.select_time.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: GVColors.blackWithAlpha60, // rgba(0,0,0,0.6)
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Time display
                  Row(
                    children: [
                      Row(
                        children: [
                          // Hour selection
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSelectingHour = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _isSelectingHour
                                    ? GVColors.materialBlue.withValues(
                                        alpha: 0.1,
                                      )
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (_selectedTime.hourOfPeriod == 0
                                        ? 12
                                        : _selectedTime.hourOfPeriod)
                                    .toString()
                                    .padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w400,
                                  color: _isSelectingHour
                                      ? GVColors.materialBlue
                                      : GVColors.blackWithAlpha60,
                                  height: 1.167,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            ':',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w400,
                              color: GVColors.blackWithAlpha60,
                              height: 1.167,
                            ),
                          ),
                          // Minute selection
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSelectingHour = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: !_isSelectingHour
                                    ? GVColors.materialBlue.withValues(
                                        alpha: 0.1,
                                      )
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _selectedTime.minute.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w400,
                                  color: !_isSelectingHour
                                      ? GVColors.materialBlue
                                      : GVColors.blackWithAlpha60,
                                  height: 1.167,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          // AM Button
                          InkWell(
                            onTap: () => _togglePeriod(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.am,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _isAM
                                      ? const Color(
                                          0xDD000000,
                                        ) // rgba(0,0,0,0.87)
                                      : const Color(
                                          0x99000000,
                                        ), // rgba(0,0,0,0.6)
                                  letterSpacing: 0.1,
                                  height: 1.57,
                                ),
                              ),
                            ),
                          ),
                          // PM Button
                          InkWell(
                            onTap: () => _togglePeriod(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.pm,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: !_isAM
                                      ? const Color(
                                          0xDD000000,
                                        ) // rgba(0,0,0,0.87)
                                      : const Color(
                                          0x99000000,
                                        ), // rgba(0,0,0,0.6)
                                  letterSpacing: 0.1,
                                  height: 1.57,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Clock
            SizedBox(
              height: 248,
              width: 320,
              child: ClockWidget(
                selectedTime: _selectedTime,
                onHourChanged: _onHourChanged,
                onMinuteChanged: _onMinuteChanged,
                isSelectingHour: _isSelectingHour,
              ),
            ),
            // Footer buttons
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      l10n.cancel_button.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: GVColors.materialBlue,
                        letterSpacing: 0.4,
                        height: 24 / 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // OK button
                  TextButton(
                    onPressed: () {
                      widget.onTimeChanged?.call(_selectedTime);
                      Navigator.of(context).pop(_selectedTime);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      l10n.ok.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: GVColors.materialBlue,
                        letterSpacing: 0.4,
                        height: 24 / 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockWidget extends StatefulWidget {
  final TimeOfDay selectedTime;
  final ValueChanged<int>? onHourChanged;
  final ValueChanged<int>? onMinuteChanged;
  final bool isSelectingHour;

  const ClockWidget({
    super.key,
    required this.selectedTime,
    this.onHourChanged,
    this.onMinuteChanged,
    required this.isSelectingHour,
  });

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(52, 16, 48, 12),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CustomPaint(
          painter: ClockPainter(
            selectedTime: widget.selectedTime,
            isSelectingHour: widget.isSelectingHour,
          ),
          child: GestureDetector(
            onPanUpdate: (details) {
              _handlePan(details.localPosition);
            },
            onTapUp: (details) {
              _handlePan(details.localPosition);
            },
          ),
        ),
      ),
    );
  }

  void _handlePan(Offset localPosition) {
    final center = Offset(110, 110); // Approximate center of the clock
    final angle = math.atan2(
      localPosition.dy - center.dy,
      localPosition.dx - center.dx,
    );

    if (widget.isSelectingHour) {
      // Convert angle to hour (12-hour format)
      double normalizedAngle = (angle + math.pi / 2) % (2 * math.pi);
      if (normalizedAngle < 0) normalizedAngle += 2 * math.pi;

      int hour = ((normalizedAngle / (math.pi / 6)).round() % 12);
      if (hour == 0) hour = 12;

      widget.onHourChanged?.call(hour);
    } else {
      // Convert angle to minute
      double normalizedAngle = (angle + math.pi / 2) % (2 * math.pi);
      if (normalizedAngle < 0) normalizedAngle += 2 * math.pi;

      int minute = ((normalizedAngle / (math.pi / 30)).round() % 60);
      widget.onMinuteChanged?.call(minute);
    }
  }
}

class ClockPainter extends CustomPainter {
  final TimeOfDay selectedTime;
  final bool isSelectingHour;

  ClockPainter({required this.selectedTime, required this.isSelectingHour});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw clock background circle
    final backgroundPaint = Paint()
      ..color = GVColors.lightestGrey
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw numbers (hours or minutes)
    if (isSelectingHour) {
      _drawHourNumbers(canvas, center, radius);
    } else {
      _drawMinuteNumbers(canvas, center, radius);
    }

    // Draw clock hand
    if (isSelectingHour) {
      _drawHourHand(canvas, center, radius);
    } else {
      _drawMinuteHand(canvas, center, radius);
    }

    // Draw selected hour/minute indicator
    _drawSelectedIndicator(canvas, center, radius);
  }

  void _drawHourNumbers(Canvas canvas, Offset center, double radius) {
    const textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: GVColors.blackWithAlpha87, // rgba(0,0,0,0.87)
    );

    for (int i = 1; i <= 12; i++) {
      final angle = (i * math.pi / 6) - (math.pi / 2);
      final numberRadius = radius - 30;
      final x = center.dx + numberRadius * math.cos(angle);
      final y = center.dy + numberRadius * math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(text: i.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final offset = Offset(
        x - textPainter.width / 2,
        y - textPainter.height / 2,
      );

      textPainter.paint(canvas, offset);
    }
  }

  void _drawMinuteNumbers(Canvas canvas, Offset center, double radius) {
    const textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: GVColors.blackWithAlpha87, // rgba(0,0,0,0.87)
    );

    // Show every 5 minutes (0, 5, 10, 15, ...)
    for (int i = 0; i < 60; i += 5) {
      final angle = (i * math.pi / 30) - (math.pi / 2);
      final numberRadius = radius - 30;
      final x = center.dx + numberRadius * math.cos(angle);
      final y = center.dy + numberRadius * math.sin(angle);

      final displayNumber = i; // Show actual minute values 00, 05, 10, etc.
      final textPainter = TextPainter(
        text: TextSpan(
          text: displayNumber.toString().padLeft(2, '0'),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final offset = Offset(
        x - textPainter.width / 2,
        y - textPainter.height / 2,
      );

      textPainter.paint(canvas, offset);
    }
  }

  void _drawHourHand(Canvas canvas, Offset center, double radius) {
    final hour = selectedTime.hourOfPeriod == 0
        ? 12
        : selectedTime.hourOfPeriod;
    final angle = (hour * math.pi / 6) - (math.pi / 2);

    final handPaint = Paint()
      ..color = GVColors.materialBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final handEnd = Offset(
      center.dx + (radius - 50) * math.cos(angle),
      center.dy + (radius - 50) * math.sin(angle),
    );

    canvas.drawLine(center, handEnd, handPaint);

    // Draw center dot
    final centerDotPaint = Paint()
      ..color = GVColors.materialBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, centerDotPaint);
  }

  void _drawMinuteHand(Canvas canvas, Offset center, double radius) {
    final angle = (selectedTime.minute * math.pi / 30) - (math.pi / 2);

    final handPaint = Paint()
      ..color = GVColors.materialBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final handEnd = Offset(
      center.dx + (radius - 30) * math.cos(angle),
      center.dy + (radius - 30) * math.sin(angle),
    );

    canvas.drawLine(center, handEnd, handPaint);

    // Draw center dot
    final centerDotPaint = Paint()
      ..color = GVColors.materialBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, centerDotPaint);
  }

  void _drawSelectedIndicator(Canvas canvas, Offset center, double radius) {
    late double angle;
    late String displayText;

    if (isSelectingHour) {
      final hour = selectedTime.hourOfPeriod == 0
          ? 12
          : selectedTime.hourOfPeriod;
      angle = (hour * math.pi / 6) - (math.pi / 2);
      displayText = hour.toString();
    } else {
      angle = (selectedTime.minute * math.pi / 30) - (math.pi / 2);
      displayText = selectedTime.minute.toString().padLeft(2, '0');
    }

    final indicatorRadius = radius - 30;
    final indicatorCenter = Offset(
      center.dx + indicatorRadius * math.cos(angle),
      center.dy + indicatorRadius * math.sin(angle),
    );

    // Draw selected value background
    final selectedPaint = Paint()
      ..color = GVColors.materialBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(indicatorCenter, 15, selectedPaint);

    // Draw selected value text
    const selectedTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: GVColors.white,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: displayText, style: selectedTextStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textOffset = Offset(
      indicatorCenter.dx - textPainter.width / 2,
      indicatorCenter.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
