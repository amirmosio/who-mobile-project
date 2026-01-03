import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/widgets/formfields/my_text_formfield.dart';
import 'package:who_mobile_project/providers/auth/auth_provider.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';

/// Dialog for creating a new admin user
/// Only accessible by super admin
class CreateAdminDialog extends ConsumerStatefulWidget {
  const CreateAdminDialog({super.key});

  @override
  ConsumerState<CreateAdminDialog> createState() => _CreateAdminDialogState();
}

class _CreateAdminDialogState extends ConsumerState<CreateAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) {
      _showError('Unable to get current user');
      setState(() => _isLoading = false);
      return;
    }

    final success = await ref.read(authProvider.notifier).createAdmin(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim().isNotEmpty
              ? _displayNameController.text.trim()
              : null,
          createdBy: currentUser.uid ?? 'unknown',
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Admin created successfully',
            style: AppTextStyles.smallText.copyWith(color: GVColors.white),
          ),
          backgroundColor: GVColors.greenSuccess,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.smallText.copyWith(color: GVColors.white),
        ),
        backgroundColor: GVColors.redError,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors
    ref.listen(authProvider, (previous, next) {
      if (next is BaseApiError) {
        _showError(next.exception.message ?? 'Failed to create admin');
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: GVColors.purpleAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person_add,
                        color: GVColors.purpleAccent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Create Admin',
                        style: AppTextStyles.headingH2.copyWith(
                          color: GVColors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: GVColors.darkGrey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Display name field (optional)
                MyTextFormField(
                  controller: _displayNameController,
                  hintText: 'Enter display name',
                  labelText: 'Display Name',
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 16),

                // Email field
                MyTextFormField(
                  controller: _emailController,
                  hintText: 'Enter email address',
                  labelText: 'Email',
                  isMandatoryStartSign: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                const SizedBox(height: 16),

                // Password field
                MyTextFormField(
                  controller: _passwordController,
                  hintText: 'Enter password',
                  labelText: 'Password',
                  isMandatoryStartSign: true,
                  obscureText: true,
                  validator: _validatePassword,
                ),

                const SizedBox(height: 8),

                // Password hint
                Text(
                  'Password must be at least 6 characters',
                  style: AppTextStyles.subtitleText.copyWith(
                    color: GVColors.darkGrey,
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            _isLoading ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: GVColors.purpleAccent,
                          side: BorderSide(color: GVColors.purpleAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.buttonSmall.copyWith(
                            color: GVColors.purpleAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleCreate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GVColors.purpleAccent,
                          foregroundColor: GVColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          disabledBackgroundColor:
                              GVColors.purpleAccent.withValues(alpha: 0.6),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    GVColors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Create',
                                style: AppTextStyles.buttonSmall.copyWith(
                                  color: GVColors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
