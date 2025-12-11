import 'package:flutter/material.dart';

// TODO: Removed - Authentication system no longer available
// This is a placeholder page since login functionality was removed
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(
        child: Text('Login functionality has been removed'),
      ),
    );
  }
}
