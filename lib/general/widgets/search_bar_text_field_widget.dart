import 'dart:async';
import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';

class SearchBarTextFieldWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onDelayedChange;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Duration debounceDelay;

  const SearchBarTextFieldWidget({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onDelayedChange,
    this.controller,
    this.margin,
    this.height,
    this.debounceDelay = const Duration(milliseconds: 500),
  });

  @override
  State<SearchBarTextFieldWidget> createState() =>
      _SearchBarTextFieldWidgetState();
}

class _SearchBarTextFieldWidgetState extends State<SearchBarTextFieldWidget> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    // Call immediate onChanged callback if provided
    widget.onChanged?.call(value);

    // Handle debounced callback
    if (widget.onDelayedChange != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceDelay, () {
        widget.onDelayedChange?.call(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: _onTextChanged,
      style: const TextStyle(
        fontSize: 12,
        color: GVColors.black,
        letterSpacing: -0.408,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: GVColors.white,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontSize: 12,
          color: GVColors.black,
          letterSpacing: -0.408,
        ),
        prefixIcon: const Icon(Icons.search, size: 16, color: GVColors.black),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GVColors.lightBorderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GVColors.lightBorderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GVColors.lightBorderGrey),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        isDense: true,
      ),
    );
  }
}
