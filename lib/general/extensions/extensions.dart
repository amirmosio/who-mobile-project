import 'package:flutter/material.dart';

extension ListSpaceBetweenExtension on List<Widget> {
  List<Widget> withWidgetInBetween(Widget widget) => [
    for (int i = 0; i < length; i++) ...[if (i > 0) widget, this[i]],
  ];

  List<Widget> withChildPadding(EdgeInsetsGeometry padding) {
    return [
      for (int i = 0; i < length; i++)
        Padding(padding: padding, child: this[i]),
    ];
  }
}

extension DoublePrecision on double? {
  String get roundString {
    return double.tryParse(this?.toStringAsFixed(3) ?? "-")?.toString() ?? "-";
  }
}
