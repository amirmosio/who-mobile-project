# Test Suite - WHO Mobile Project

This directory contains the test suite for the WHO Mobile Project. The tests are organized into three main categories: **Unit Tests**, **Widget Tests**, and **Integration Tests**.

## Table of Contents
- [Overview](#overview)
- [Test Structure](#test-structure)
- [Running Tests](#running-tests)
- [Writing Tests](#writing-tests)
- [Best Practices](#best-practices)
- [Coverage Reports](#coverage-reports)
- [CI/CD Integration](#cicd-integration)

## Overview

The test suite follows Flutter's testing best practices and is organized by test type:

- **Unit Tests:** Test individual functions, methods, and classes in isolation
- **Widget Tests:** Test Flutter widgets and UI components
- **Integration Tests:** Test complete user flows and app behavior end-to-end

## Test Structure

```
test/
├── unit/
│   ├── models/
│   │   └── packing_list_item_test.dart
│   └── services/
│       └── navigation_tracker_test.dart
├── widget/
│   └── ui/
│       └── sample_widget_test.dart
└── README.md (this file)

integration_test/
└── app_test.dart
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Unit Tests Only
```bash
flutter test test/unit/
```

### Run Widget Tests Only
```bash
flutter test test/widget/
```

### Run a Specific Test File
```bash
flutter test test/unit/models/packing_list_item_test.dart
```

### Run Integration Tests
```bash
# Method 1: Using flutter test
flutter test integration_test/app_test.dart

# Method 2: Using flutter drive (on physical device/emulator)
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

### Run Tests with Coverage
```bash
# Generate coverage report
flutter test --coverage

# View coverage in HTML format (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Tests in Watch Mode
```bash
# Install flutter_test_runner (if not already installed)
dart pub global activate flutter_test_runner

# Run in watch mode
flutter_test_runner
```

## Writing Tests

### Unit Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_package/your_class.dart';

void main() {
  group('YourClass', () {
    test('should do something', () {
      // Arrange
      final instance = YourClass();

      // Act
      final result = instance.doSomething();

      // Assert
      expect(result, expectedValue);
    });
  });
}
```

### Widget Test Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should display text', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Text('Hello'),
        ),
      ),
    );

    // Assert
    expect(find.text('Hello'), findsOneWidget);
  });
}
```

### Integration Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:your_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app flow test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Test your app flow
  });
}
```

## Best Practices

### 1. Test Organization
- Group related tests using `group()`
- Use descriptive test names that explain what is being tested
- Follow the Arrange-Act-Assert (AAA) pattern

### 2. Test Independence
- Each test should be independent and not rely on other tests
- Use `setUp()` and `tearDown()` for common initialization and cleanup
- Avoid global state

### 3. Mocking
- Use `mockito` for creating mock objects
- Mock external dependencies (APIs, databases, etc.)
- Don't mock the system under test

### 4. Coverage
- Aim for > 80% code coverage for unit tests
- Focus on testing critical business logic
- Don't obsess over 100% coverage - quality over quantity

### 5. Test Naming
```dart
// Good
test('should return user when login is successful', () {});

// Bad
test('login test', () {});
```

### 6. Widget Testing
- Use `pumpWidget()` to build widgets
- Use `pumpAndSettle()` to wait for animations
- Use specific finders (`find.byKey`, `find.text`, etc.)

### 7. Integration Testing
- Test complete user journeys
- Test on real devices when possible
- Keep tests focused on user behavior

## Coverage Reports

### Generate Coverage
```bash
flutter test --coverage
```

### View Coverage Report
The coverage report is generated in `coverage/lcov.info`. You can view it using:

```bash
# macOS/Linux
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Windows
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

### CI Coverage Integration
Coverage reports can be uploaded to services like:
- Codecov
- Coveralls
- CodeClimate

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.0'
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v2
        with:
          files: coverage/lcov.info
```

## Useful Commands

### Clean and Get Dependencies
```bash
flutter clean
flutter pub get
```

### Run Tests with Verbose Output
```bash
flutter test --verbose
```

### Run Tests with Custom Reporter
```bash
flutter test --reporter expanded
```

### Run Tests for Specific Platform
```bash
flutter test --platform chrome
```

### Update Golden Files (for widget tests)
```bash
flutter test --update-goldens
```

## Troubleshooting

### Common Issues

**Issue:** Tests fail with dependency injection errors
**Solution:** Ensure all dependencies are properly mocked or initialized in `setUp()`

**Issue:** Widget tests timeout
**Solution:** Increase timeout or use `pumpAndSettle()` instead of `pump()`

**Issue:** Integration tests fail on CI
**Solution:** Ensure Firebase and other services are properly configured for testing

**Issue:** Coverage not generating
**Solution:** Make sure you're using `flutter test --coverage` and not `flutter run`

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Flutter Test Package](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Test Campaign Document](../docs/TEST_CAMPAIGN.md)

## Contributing

When contributing new code:
1. Write tests for new features
2. Update existing tests when modifying functionality
3. Ensure all tests pass before submitting PR
4. Maintain or improve code coverage
5. Follow the existing test patterns and conventions

---

For more information about the test campaign and strategy, see [TEST_CAMPAIGN.md](../docs/TEST_CAMPAIGN.md)
