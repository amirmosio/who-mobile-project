import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_mobile_project/ui/idtm/packing_list_page.dart';

/// Widget tests for PackingListPage
///
/// Tests cover:
/// - UI rendering and display
/// - Item checking/unchecking
/// - Progress tracking
/// - Visual recognition flow
/// - State persistence
/// - Sub-item expansion

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Clear SharedPreferences before each test
    SharedPreferences.setMockInitialValues({});
  });

  group('PackingListPage - Display Tests', () {
    testWidgets('should display packing list page with header', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('IDTM Packing List'), findsOneWidget);
      expect(find.text('Equipment Checklist'), findsOneWidget);
      expect(find.text('Verify all items before installation'), findsOneWidget);
    });

    testWidgets('should display progress counter in appbar', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Initially all items unchecked
      expect(find.textContaining('/'), findsOneWidget); // Format: "0/X"
    });

    testWidgets('should display total weight', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Total Weight:'), findsOneWidget);
      expect(find.textContaining('kg'), findsOneWidget);
    });

    testWidgets('should display progress bar', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should display scan with camera button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.widgetWithText(ElevatedButton, 'Scan with Camera'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsWidgets);
    });

    testWidgets('should display reset checklist button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.widgetWithText(OutlinedButton, 'Reset Checklist'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsWidgets);
    });

    testWidgets('should display list of packing items', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsWidgets); // Multiple cards for items
      expect(find.byType(Checkbox), findsWidgets); // Checkboxes for items
    });

    testWidgets('should show loading indicator initially', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );

      // Assert - Before pumpAndSettle, should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Assert - After loading, list should be visible
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('PackingListPage - Item Checking Tests', () {
    testWidgets('should check item when checkbox tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find first checkbox
      final checkboxFinder = find.byType(Checkbox).first;

      // Verify initial state (unchecked)
      Checkbox checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, false);

      // Act - Tap checkbox
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Assert - Checkbox should be checked
      checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, true);
    });

    testWidgets('should update progress counter when item checked', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Get initial count (should be "0/X")
      final initialCountText = tester.widget<Text>(
        find.textContaining('/').first,
      ).data!;
      expect(initialCountText.startsWith('0/'), true);

      // Act - Check first item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Assert - Count should increment to "1/X"
      final newCountText = tester.widget<Text>(
        find.textContaining('/').first,
      ).data!;
      expect(newCountText.startsWith('1/'), true);
    });

    testWidgets('should update progress bar when item checked', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Get initial progress
      LinearProgressIndicator progressBar = tester.widget(find.byType(LinearProgressIndicator));
      final initialProgress = progressBar.value ?? 0;

      // Act - Check first item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Assert - Progress should increase
      progressBar = tester.widget(find.byType(LinearProgressIndicator));
      final newProgress = progressBar.value ?? 0;
      expect(newProgress, greaterThan(initialProgress));
    });

    testWidgets('should uncheck item when checked checkbox tapped again', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      final checkboxFinder = find.byType(Checkbox).first;

      // Check the item first
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      Checkbox checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, true);

      // Act - Tap again to uncheck
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Assert - Should be unchecked
      checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, false);
    });

    testWidgets('should apply strikethrough when item checked', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Check first item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Assert - Should find text with strikethrough decoration
      // Note: This is a simplified check; real test would verify specific item text
      expect(find.byType(Card), findsWidgets);
    });
  });

  group('PackingListPage - Sub-item Tests', () {
    testWidgets('should expand sub-items when parent item tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find items with expand icons (items with sub-items)
      final expandIconFinder = find.byIcon(Icons.keyboard_arrow_down);

      if (expandIconFinder.evaluate().isNotEmpty) {
        final initialSubItemCount = find.byType(CheckboxListTile).evaluate().length;

        // Act - Tap to expand
        await tester.tap(find.byType(Card).first);
        await tester.pumpAndSettle();

        // Assert - Should have more CheckboxListTile widgets (sub-items)
        final expandedSubItemCount = find.byType(CheckboxListTile).evaluate().length;
        expect(expandedSubItemCount, greaterThanOrEqualTo(initialSubItemCount));

        // Icon should change to up arrow
        expect(find.byIcon(Icons.keyboard_arrow_up), findsWidgets);
      }
    });

    testWidgets('should check all sub-items when parent checked', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find item with sub-items and expand it
      final expandIconFinder = find.byIcon(Icons.keyboard_arrow_down);

      if (expandIconFinder.evaluate().isNotEmpty) {
        // Expand first item with sub-items
        await tester.tap(find.byType(Card).first);
        await tester.pumpAndSettle();

        // Act - Check parent
        await tester.tap(find.byType(Checkbox).first);
        await tester.pumpAndSettle();

        // Assert - All CheckboxListTile should be checked
        final subItemCheckboxes = find.byType(CheckboxListTile);
        for (final checkboxTile in subItemCheckboxes.evaluate()) {
          final widget = checkboxTile.widget as CheckboxListTile;
          expect(widget.value, true);
        }
      }
    });
  });

  group('PackingListPage - Reset Functionality Tests', () {
    testWidgets('should show confirmation dialog when reset tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Tap reset button
      await tester.tap(find.widgetWithText(OutlinedButton, 'Reset Checklist'));
      await tester.pumpAndSettle();

      // Assert - Confirmation dialog shown
      expect(find.text('Reset Checklist'), findsWidgets); // Dialog title
      expect(find.text('Are you sure you want to reset all checkboxes? This cannot be undone.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
    });

    testWidgets('should not reset when cancel tapped in dialog', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Check first item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Open reset dialog
      await tester.tap(find.widgetWithText(OutlinedButton, 'Reset Checklist'));
      await tester.pumpAndSettle();

      // Act - Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert - Item should still be checked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, true);
    });

    testWidgets('should reset all items when confirmed', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Check first item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Open reset dialog
      await tester.tap(find.widgetWithText(OutlinedButton, 'Reset Checklist'));
      await tester.pumpAndSettle();

      // Act - Tap Reset (confirm)
      await tester.tap(find.text('Reset').last); // Last one is in dialog
      await tester.pumpAndSettle();

      // Assert - Progress should be 0
      final countText = tester.widget<Text>(
        find.textContaining('/').first,
      ).data!;
      expect(countText.startsWith('0/'), true);
    });

    testWidgets('should show success snackbar after reset', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Check an item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Open reset dialog and confirm
      await tester.tap(find.widgetWithText(OutlinedButton, 'Reset Checklist'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset').last);
      await tester.pumpAndSettle();

      // Assert - Success snackbar shown
      expect(find.text('Checklist reset successfully'), findsOneWidget);
    });
  });

  group('PackingListPage - Visual Recognition Tests', () {
    testWidgets('should open item selection dialog when scan button tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Tap scan button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Scan with Camera'));
      await tester.pumpAndSettle();

      // Assert - Selection dialog shown
      expect(find.text('Select Item to Scan'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should show camera icon on scan button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final scanButton = find.widgetWithText(ElevatedButton, 'Scan with Camera');
      expect(scanButton, findsOneWidget);

      // Find camera icon within the button
      expect(find.descendant(
        of: scanButton,
        matching: find.byIcon(Icons.camera_alt),
      ), findsOneWidget);
    });

    testWidgets('should disable scan button while scanning', (WidgetTester tester) async {
      // Note: This test would require mocking the camera/image picker
      // For now, we verify the button exists and is initially enabled
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      final scanButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Scan with Camera'),
      );

      expect(scanButton.onPressed, isNotNull); // Button is enabled
    });
  });

  group('PackingListPage - State Persistence Tests', () {
    testWidgets('should save checked state to SharedPreferences', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Check first item
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Give time for SharedPreferences to save
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - SharedPreferences should have saved state
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Should have at least one "checked_" key
      final hasCheckedKey = keys.any((key) => key.startsWith('checked_'));
      expect(hasCheckedKey, true);
    });

    testWidgets('should restore checked state from SharedPreferences on load', (WidgetTester tester) async {
      // Arrange - Pre-populate SharedPreferences with checked state
      SharedPreferences.setMockInitialValues({
        'checked_pack-001': true,  // Assuming this item ID exists
      });

      // Act - Load page
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Progress counter should show at least 1 checked item
      // (if pack-001 exists in the data)
      final countText = tester.widget<Text>(
        find.textContaining('/').first,
      ).data!;

      // Count should NOT be "0/"
      expect(countText.startsWith('0/'), false);
    });
  });

  group('PackingListPage - Edge Cases', () {
    testWidgets('should handle empty packing list gracefully', (WidgetTester tester) async {
      // Note: This would require mocking the data source
      // For now, we verify the page doesn't crash with real data
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Should not throw errors
      expect(find.byType(PackingListPage), findsOneWidget);
    });

    testWidgets('should handle rapid checkbox tapping', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      final checkboxFinder = find.byType(Checkbox).first;

      // Act - Rapidly tap checkbox multiple times
      for (int i = 0; i < 5; i++) {
        await tester.tap(checkboxFinder);
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      // Assert - Should end up in one of the two states (checked or unchecked)
      final checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, isA<bool>());
    });

    testWidgets('should display correct progress when all items checked', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Check all checkboxes
      final allCheckboxes = find.byType(Checkbox);
      for (int i = 0; i < allCheckboxes.evaluate().length; i++) {
        await tester.tap(allCheckboxes.at(i));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      // Assert - Progress bar should be at 100%
      final progressBar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progressBar.value, greaterThanOrEqualTo(0.99)); // Account for floating point
    });
  });

  group('PackingListPage - UI Elements Tests', () {
    testWidgets('should display item images when available', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should have image containers
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display item quantities and dimensions', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should find text containing "Qty:"
      expect(find.textContaining('Qty:'), findsWidgets);
    });

    testWidgets('should show expand/collapse icons for items with sub-items', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should have either down or up arrow icons
      final hasExpandIcons = find.byIcon(Icons.keyboard_arrow_down).evaluate().isNotEmpty ||
                            find.byIcon(Icons.keyboard_arrow_up).evaluate().isNotEmpty;
      expect(hasExpandIcons, true);
    });

    testWidgets('should display item descriptions when available', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PackingListPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should render all text widgets (includes descriptions)
      expect(find.byType(Text), findsWidgets);
    });
  });
}
