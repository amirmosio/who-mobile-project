import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import "package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart";
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/app_core/theme/icons.dart';

class YRExpandableWidget extends StatefulWidget {
  final Widget child;
  final String title;
  final Function() onValidatedAndSubmitted;
  final Function() onRemoving;
  final Function() onResetting;
  final VoidCallback? onExpandButton;
  final bool isExpanded;
  final Widget? collapsedEditedWidget;

  const YRExpandableWidget({
    super.key,
    required this.child,
    required this.title,
    required this.onValidatedAndSubmitted,
    this.isExpanded = false,
    this.onExpandButton,
    required this.collapsedEditedWidget,
    required this.onResetting,
    required this.onRemoving,
  });

  @override
  State<YRExpandableWidget> createState() => _YRExpandableWidgetState();
}

class _YRExpandableWidgetState extends State<YRExpandableWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 200),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              widget.onExpandButton?.call();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(widget.title, style: AppTextStyles.headingH2),
                    ),
                    widget.isExpanded ? SizedBox() : expandButtonWidget(),
                  ],
                ),
                !widget.isExpanded && widget.collapsedEditedWidget != null
                    ? widget.collapsedEditedWidget!
                    : SizedBox(),
              ],
            ),
          ),
          widget.isExpanded
              ? Column(
                  children: [
                    const SizedBox(height: 16.0),
                    Form(key: _formKey, child: widget.child),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GVColors.purpleAccent,
                            fixedSize: Size(130, 40),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.onValidatedAndSubmitted.call();
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.save,
                            style: AppTextStyles.buttonPrimary.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            widget.onResetting();
                          },
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size(130, 40),
                            side: const BorderSide(
                              color: GVColors.purpleAccent,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: AppTextStyles.buttonPrimary.copyWith(
                              color: GVColors.purpleAccent,
                            ),
                          ),
                        ),
                        if (widget.collapsedEditedWidget != null)
                          IconButton(
                            onPressed: () {
                              widget.onRemoving();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: GVColors.eliminateButtonColor,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                )
              : SizedBox(),
          widget.isExpanded || widget.collapsedEditedWidget != null
              ? Divider(color: GVColors.borderGrey, thickness: 0.5)
              : SizedBox(),
        ],
      ),
    );
  }

  Widget expandButtonWidget() {
    if (widget.collapsedEditedWidget != null) {
      return Icon(YRIcons.edit);
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: GVColors.purpleAccent,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.center,
        child: Icon(Icons.add, color: GVColors.white),
      );
    }
  }
}
