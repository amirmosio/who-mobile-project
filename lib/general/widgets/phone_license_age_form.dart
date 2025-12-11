import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/general/utils/string_validators.dart';
import 'package:who_mobile_project/ui/auth_pages/widgets/auth_form_field.dart';

/// Reusable form widget that collects phone number, when user wants license, and current age
class PhoneLicenseAgeForm extends StatefulWidget {
  /// Title/message to display above the form
  final String title;

  /// Callback function called when form is submitted with valid data
  /// Parameters: (phoneNumber, whenLicense, age)
  final Function(String phoneNumber, String whenLicense, String age) onSubmit;

  /// Optional submit button text. Defaults to feedback_submit localization
  final String? submitButtonText;

  /// Optional title style. Defaults to AppTextStyles.bodyTextStrong with purple accent
  final TextStyle? titleStyle;

  /// Optional color for both the title text and submit button. Defaults to purpleAccent
  final Color? color;

  const PhoneLicenseAgeForm({
    super.key,
    required this.title,
    required this.onSubmit,
    this.submitButtonText,
    this.titleStyle,
    this.color,
  });

  @override
  State<PhoneLicenseAgeForm> createState() => _PhoneLicenseAgeFormState();
}

class _PhoneLicenseAgeFormState extends State<PhoneLicenseAgeForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _whenLicenseController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _whenLicenseController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _phoneController.text,
        _whenLicenseController.text,
        _ageController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style:
                widget.titleStyle ??
                AppTextStyles.bodyTextStrong.copyWith(
                  color: widget.color ?? GVColors.purpleAccent,
                ),
          ),
        ),
        const SizedBox(height: 24),
        // Form
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormField(
                label: AppLocalizations.of(context)!.phone_number,
                controller: _phoneController,
                hint: AppLocalizations.of(context)!.phone_hint,
                validator: (value) =>
                    StringValidators.phoneValidator(context, value),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              AuthFormField(
                label: AppLocalizations.of(context)!.when_want_license,
                controller: _whenLicenseController,
                hint: AppLocalizations.of(context)!.when_want_license_hint,
                validator: (value) =>
                    StringValidators.stringValidator(context, value),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              AuthFormField(
                label: AppLocalizations.of(context)!.current_age,
                controller: _ageController,
                hint: AppLocalizations.of(context)!.current_age_hint,
                validator: (value) =>
                    StringValidators.integerValidator(context, value),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color ?? GVColors.purpleAccent,
                  foregroundColor: GVColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.submitButtonText ??
                      AppLocalizations.of(context)!.feedback_submit,
                  style: AppTextStyles.buttonPrimary.copyWith(
                    color: GVColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
