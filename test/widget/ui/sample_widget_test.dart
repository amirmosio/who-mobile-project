import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This is a sample widget test demonstrating Flutter widget testing patterns
///
/// Widget tests verify that widgets display correctly and respond to user interactions.
/// They test the UI layer without requiring a physical device or emulator.
///
/// Key concepts:
/// - Use WidgetTester to interact with widgets
/// - Use Finder to locate widgets in the widget tree
/// - Use expect() to verify widget properties and behavior
/// - Wrap your widget in MaterialApp for proper context

void main() {
  group('Sample Widget Tests', () {
    testWidgets('should display text widget', (WidgetTester tester) async {
      // Arrange: Build a simple text widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Hello World'),
          ),
        ),
      );

      // Act & Assert: Find and verify the text widget
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('should respond to button tap', (WidgetTester tester) async {
      // Arrange: Create a stateful widget with a counter
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _CounterWidget(),
          ),
        ),
      );

      // Assert initial state
      expect(find.text('Count: 0'), findsOneWidget);

      // Act: Tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Rebuild the widget after state change

      // Assert: Verify the counter increased
      expect(find.text('Count: 1'), findsOneWidget);
      expect(find.text('Count: 0'), findsNothing);
    });

    testWidgets('should display list of items', (WidgetTester tester) async {
      // Arrange: Create a list widget
      final items = ['Item 1', 'Item 2', 'Item 3'];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
        ),
      );

      // Assert: Verify all items are displayed
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('should handle text input', (WidgetTester tester) async {
      // Arrange: Build a text field
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextField(
              key: Key('test_field'),
            ),
          ),
        ),
      );

      // Act: Enter text
      await tester.enterText(find.byKey(const Key('test_field')), 'Test Input');
      await tester.pump();

      // Assert: Verify text was entered
      expect(find.text('Test Input'), findsOneWidget);
    });

    testWidgets('should display icon based on condition',
        (WidgetTester tester) async {
      // Arrange: Build a widget with conditional icon
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _ConditionalIconWidget(isCompleted: true),
          ),
        ),
      );

      // Assert: Verify correct icon is displayed
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsNothing);
    });

    testWidgets('should update UI when state changes',
        (WidgetTester tester) async {
      // Arrange: Build a toggleable widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _ToggleWidget(),
          ),
        ),
      );

      // Assert initial state
      expect(find.text('OFF'), findsOneWidget);

      // Act: Toggle the state
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Assert: Verify UI updated
      expect(find.text('ON'), findsOneWidget);
      expect(find.text('OFF'), findsNothing);
    });

    testWidgets('should render card with proper styling',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Card Content'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('should navigate on button press', (WidgetTester tester) async {
      // Arrange: Build a navigation test widget
      await tester.pumpWidget(
        MaterialApp(
          home: _NavigationTestWidget(),
        ),
      );

      // Assert initial screen
      expect(find.text('Home Screen'), findsOneWidget);

      // Act: Tap navigation button
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle(); // Wait for navigation animation

      // Assert: Verify navigation occurred
      expect(find.text('Details Screen'), findsOneWidget);
      expect(find.text('Home Screen'), findsNothing);
    });

    testWidgets('should display CircleAvatar with correct properties',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              child: Text('A'),
            ),
          ),
        ),
      );

      // Assert
      final CircleAvatar avatar = tester.widget(find.byType(CircleAvatar));
      expect(avatar.radius, 20);
      expect(avatar.backgroundColor, Colors.blue);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('should display progress indicator with correct value',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LinearProgressIndicator(value: 0.5),
          ),
        ),
      );

      // Assert
      final LinearProgressIndicator indicator =
          tester.widget(find.byType(LinearProgressIndicator));
      expect(indicator.value, 0.5);
    });
  });
}

// Sample stateful widget for testing
class _CounterWidget extends StatefulWidget {
  @override
  State<_CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<_CounterWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Count: $_counter'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _counter++;
            });
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}

// Sample widget with conditional icon
class _ConditionalIconWidget extends StatelessWidget {
  final bool isCompleted;

  const _ConditionalIconWidget({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
      color: isCompleted ? Colors.green : Colors.grey,
    );
  }
}

// Sample toggle widget
class _ToggleWidget extends StatefulWidget {
  @override
  State<_ToggleWidget> createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<_ToggleWidget> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_isOn ? 'ON' : 'OFF'),
        Switch(
          value: _isOn,
          onChanged: (value) {
            setState(() {
              _isOn = value;
            });
          },
        ),
      ],
    );
  }
}

// Sample navigation widget
class _NavigationTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Screen'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _DetailsScreen(),
                  ),
                );
              },
              child: Text('Go to Details'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Details Screen'),
      ),
    );
  }
}
