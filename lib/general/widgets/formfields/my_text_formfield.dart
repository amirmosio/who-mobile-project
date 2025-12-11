import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? delayedOnChange;
  final String? labelText;
  final bool isMandatoryStartSign;
  final double borderRadius;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final TextStyle? hintTextStyle;
  final Widget? suffixIcon;
  final Duration delayDuration;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool enabled;
  final TextAlign textAlign;
  final VoidCallback? onTap;
  final double? labelButtonPadding;

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.labelText,
    this.isMandatoryStartSign = false,
    this.borderRadius = 30,
    this.validator,
    this.fillColor,
    this.hintTextStyle,
    this.suffixIcon,
    this.delayDuration = const Duration(milliseconds: 500),
    this.delayedOnChange,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.onTap,
    this.labelButtonPadding,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  Timer? _debounce;
  late bool isObscured;

  @override
  void initState() {
    isObscured = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: GVColors.mediumLightGrey, width: 0.5),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText != null
            ? Padding(
                padding: EdgeInsets.only(
                  bottom: widget.labelButtonPadding ?? 15,
                ),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyText.copyWith(
                      color: GVColors.black,
                    ),
                    children: [
                      TextSpan(
                        text: widget.labelText ?? "",
                        style: AppTextStyles.bodyText,
                      ),
                      TextSpan(
                        text: widget.isMandatoryStartSign ? " *" : "",
                        style: AppTextStyles.bodyText.copyWith(
                          color: GVColors.redError,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(),
        TextFormField(
          controller: widget.controller,
          obscureText: isObscured,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          textAlign: widget.textAlign,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(widget.delayDuration, () {
              widget.delayedOnChange?.call(value);
            });
          },
          style: AppTextStyles.smallText,
          validator: widget.validator,
          onTap: widget.onTap,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintTextStyle,
            errorStyle: AppTextStyles.inputFieldError,
            filled: true,
            fillColor: widget.fillColor ?? GVColors.greyFieldBackground,
            focusedErrorBorder: border,
            border: border,
            errorBorder: border,
            focusedBorder: border,
            disabledBorder: border,
            enabledBorder: border,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffixIcon:
                widget.suffixIcon ??
                (widget.obscureText ? obscureSuffixWidget() : null),
          ),
        ),
      ],
    );
  }

  Widget obscureSuffixWidget() {
    return IconButton(
      onPressed: () {
        setState(() {
          isObscured = !isObscured;
        });
      },
      icon: Icon(
        isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: GVColors.greyIcon,
      ),
    );
  }
}
