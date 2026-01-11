import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/facility_use_card.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/idtm_status_card.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/what_is_idtm_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
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
    final currentUserAsync = ref.watch(currentUserProvider);
    final isAuthenticated = switch (currentUserAsync) {
      AsyncData(:final value) => value.isAuthenticated,
      _ => false,
    };

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
              // What is IDTM Card - shown to everyone
              const WhatIsIdtmCard(),

              // IDTM Status Card - only for authenticated users
              if (isAuthenticated)
                IdtmStatusCard(key: _cardKey, onStatusChanged: _refreshCard),

              // Facility Use & Functioning Card - only for authenticated users
              if (isAuthenticated) const FacilityUseCard(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
