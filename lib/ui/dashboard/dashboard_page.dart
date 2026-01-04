import 'package:flutter/material.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/idtm_guide_card.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/idtm_status_card.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/what_is_idtm_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  // Use a key to force rebuild of the IDTM status card
  Key _cardKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh when app comes back to foreground
      _refreshCard();
    }
  }

  void _refreshCard() {
    if (mounted) {
      setState(() {
        _cardKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshCard();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // What is IDTM Card
              const WhatIsIdtmCard(),
              // IDTM Status Card with unique key to force rebuild
              IdtmStatusCard(key: _cardKey, onStatusChanged: _refreshCard),

              // IDTM Guide Card
              const IdtmGuideCard(),

              // Add other dashboard cards here in the future
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
