import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_mobile_project/ui/dashboard/dashboard_page.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/idtm_status_card.dart';
import 'package:who_mobile_project/ui/dashboard/widgets/what_is_idtm_card.dart';

/// Widget tests for DashboardPage
///
/// Tests cover:
/// - Dashboard rendering
/// - Card display (IDTM Status, What is IDTM)
/// - Pull-to-refresh functionality
/// - Card refresh mechanism

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashboardPage - Display Tests', () {
    testWidgets('should display dashboard page with appbar', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display What is IDTM card', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(WhatIsIdtmCard), findsOneWidget);
    });

    testWidgets('should display IDTM Status card', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(IdtmStatusCard), findsOneWidget);
    });

    testWidgets('should display cards in scrollable column', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });

  group('DashboardPage - Refresh Tests', () {
    testWidgets('should have RefreshIndicator', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should trigger refresh on pull down', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Simulate pull-to-refresh gesture
      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 300), // Drag down
      );
      await tester.pumpAndSettle();

      // Assert - Page should still be displayed (refresh completed)
      expect(find.byType(DashboardPage), findsOneWidget);
      expect(find.byType(IdtmStatusCard), findsOneWidget);
    });
  });

  group('DashboardPage - Lifecycle Tests', () {
    testWidgets('should rebuild cards when app resumed', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      final initialCardCount = find.byType(IdtmStatusCard).evaluate().length;

      // Act - Simulate app going to background and back
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      // Assert - Card should still be present
      expect(find.byType(IdtmStatusCard), findsWidgets);
      expect(find.byType(IdtmStatusCard).evaluate().length, initialCardCount);
    });
  });

  group('DashboardPage - Structure Tests', () {
    testWidgets('should use AlwaysScrollableScrollPhysics', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('should have proper spacing between cards', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should have SizedBox for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
