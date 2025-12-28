import 'package:flutter/material.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/idtm_guide_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDTM Guide Card
            const IdtmGuideCard(),

            // Add other dashboard cards here in the future
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
