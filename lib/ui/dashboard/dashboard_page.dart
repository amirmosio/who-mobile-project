import 'package:flutter/material.dart';
import 'package:who_mobile_project/general/widgets/section_placeholder.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SectionPlaceholder(
          text: 'Dashboard',
        ),
      ),
    );
  }
}
