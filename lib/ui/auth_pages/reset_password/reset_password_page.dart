import 'package:flutter/material.dart';

// TODO: Removed - Authentication system no longer available
// This is a placeholder page since reset password functionality was removed
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: const Center(
        child: Text('Reset password functionality has been removed'),
      ),
    );
  }
}
