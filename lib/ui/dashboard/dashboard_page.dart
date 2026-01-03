import 'package:flutter/material.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/idtm_guide_card.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/idtm_status_card.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/installation_guide_card.dart';

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
            // Current IDTM Installation Status
            const IdtmStatusCard(),

            // Installation Guide Card (with progress tracking)
            const InstallationGuideCard(),

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
