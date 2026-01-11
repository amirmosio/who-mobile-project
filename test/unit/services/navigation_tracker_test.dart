import 'package:flutter_test/flutter_test.dart';
import 'package:who_mobile_project/services/navigation_tracker.dart';

void main() {
  group('GoRouterTracker', () {
    late GoRouterTracker tracker;

    setUp(() {
      tracker = GoRouterTracker();
      tracker.clearHistory(); // Clear history before each test
    });

    tearDown(() {
      tracker.clearHistory(); // Clean up after each test
    });

    test('should be a singleton instance', () {
      // Arrange & Act
      final instance1 = GoRouterTracker();
      final instance2 = GoRouterTracker();

      // Assert
      expect(instance1, same(instance2));
    });

    test('should track a navigation event', () {
      // Arrange & Act
      tracker.trackNavigation(
        '/home',
        '/home',
      );

      // Assert
      final info = tracker.getGoRouterInfo();
      expect(info['current_route'], '/home');
      expect(info['route_history'], contains('/home'));
    });

    test('should track navigation with parameters', () {
      // Arrange & Act
      tracker.trackNavigation(
        '/user/123',
        '/user/:id',
        params: {'id': '123'},
      );

      // Assert
      final info = tracker.getGoRouterInfo();
      expect(info['current_route'], '/user/:id');
    });

    test('should maintain navigation history', () {
      // Arrange & Act
      tracker.trackNavigation('/home', '/home');
      tracker.trackNavigation('/profile', '/profile');
      tracker.trackNavigation('/settings', '/settings');

      // Assert
      final info = tracker.getGoRouterInfo();
      final history = info['route_history'] as List;
      expect(history.length, 3);
      expect(history[0], '/settings'); // Most recent first
      expect(history[1], '/profile');
      expect(history[2], '/home');
    });

    test('should not add duplicate consecutive routes to history', () {
      // Arrange & Act
      tracker.trackNavigation('/home', '/home');
      tracker.trackNavigation('/home', '/home');
      tracker.trackNavigation('/home', '/home');

      // Assert
      final info = tracker.getGoRouterInfo();
      final history = info['route_history'] as List;
      expect(history.length, 1);
      expect(history[0], '/home');
    });

    test('should allow same route after navigating to different route', () {
      // Arrange & Act
      tracker.trackNavigation('/home', '/home');
      tracker.trackNavigation('/profile', '/profile');
      tracker.trackNavigation('/home', '/home');

      // Assert
      final info = tracker.getGoRouterInfo();
      final history = info['route_history'] as List;
      expect(history.length, 3);
      expect(history[0], '/home');
      expect(history[1], '/profile');
      expect(history[2], '/home');
    });

    test('should limit history size to maxHistorySize', () {
      // Arrange & Act
      for (int i = 0; i < 25; i++) {
        tracker.trackNavigation('/route$i', '/route$i');
      }

      // Assert
      final info = tracker.getGoRouterInfo();
      final history = info['route_history'] as List;
      expect(history.length, GoRouterTracker.maxHistorySize);
      expect(history.length, 20); // maxHistorySize is 20
    });

    test('should keep most recent routes when history exceeds limit', () {
      // Arrange & Act
      for (int i = 0; i < 25; i++) {
        tracker.trackNavigation('/route$i', '/route$i');
      }

      // Assert
      final info = tracker.getGoRouterInfo();
      final history = info['route_history'] as List;
      expect(history[0], '/route24'); // Most recent
      expect(history.contains('/route0'), false); // Oldest removed
    });

    test('should update current route on each navigation', () {
      // Arrange & Act
      tracker.trackNavigation('/home', '/home');
      var info = tracker.getGoRouterInfo();
      expect(info['current_route'], '/home');

      tracker.trackNavigation('/profile', '/profile');
      info = tracker.getGoRouterInfo();
      expect(info['current_route'], '/profile');

      tracker.trackNavigation('/settings', '/settings');
      info = tracker.getGoRouterInfo();
      expect(info['current_route'], '/settings');
    });

    test('should clear history and current route', () {
      // Arrange
      tracker.trackNavigation('/home', '/home');
      tracker.trackNavigation('/profile', '/profile');

      // Act
      tracker.clearHistory();

      // Assert
      final info = tracker.getGoRouterInfo();
      expect(info['current_route'], 'Unknown');
      final history = info['route_history'] as List;
      expect(history.isEmpty, true);
    });

    test('should return navigation summary with current route', () {
      // Arrange
      tracker.trackNavigation('/home', '/home');

      // Act
      final summary = tracker.getNavigationSummary();

      // Assert
      expect(summary, contains('Current Route: /home'));
      expect(summary, contains('Recent Navigation History:'));
    });

    test('should return message when no history available', () {
      // Arrange & Act
      final summary = tracker.getNavigationSummary();

      // Assert
      expect(summary, 'No navigation history available');
    });

    test('should limit navigation summary to 5 recent routes', () {
      // Arrange
      for (int i = 0; i < 10; i++) {
        tracker.trackNavigation('/route$i', '/route$i');
      }

      // Act
      final summary = tracker.getNavigationSummary();

      // Assert
      expect(summary, contains('/route9')); // Most recent
      expect(summary, contains('/route5')); // 5th most recent
      expect(summary.contains('/route4'), false); // 6th should not be included
    });

    test('should handle empty location strings', () {
      // Arrange & Act
      tracker.trackNavigation('', '');

      // Assert
      final info = tracker.getGoRouterInfo();
      expect(info['current_route'], '');
    });

    test('should handle complex route paths', () {
      // Arrange & Act
      tracker.trackNavigation(
        '/user/123/posts/456',
        '/user/:userId/posts/:postId',
        params: {'userId': '123', 'postId': '456'},
      );

      // Assert
      final info = tracker.getGoRouterInfo();
      expect(info['current_route'], '/user/:userId/posts/:postId');
    });
  });

  group('GoRouteInfo', () {
    test('should create a GoRouteInfo instance', () {
      // Arrange
      final timestamp = DateTime.now();

      // Act
      final routeInfo = GoRouteInfo(
        location: '/home',
        path: '/home',
        timestamp: timestamp,
      );

      // Assert
      expect(routeInfo.location, '/home');
      expect(routeInfo.path, '/home');
      expect(routeInfo.timestamp, timestamp);
      expect(routeInfo.params, isNull);
    });

    test('should create a GoRouteInfo with params', () {
      // Arrange
      final timestamp = DateTime.now();
      final params = {'id': '123', 'tab': 'profile'};

      // Act
      final routeInfo = GoRouteInfo(
        location: '/user/123?tab=profile',
        path: '/user/:id',
        timestamp: timestamp,
        params: params,
      );

      // Assert
      expect(routeInfo.params, params);
      expect(routeInfo.params!['id'], '123');
      expect(routeInfo.params!['tab'], 'profile');
    });

    test('should convert to Map correctly', () {
      // Arrange
      final timestamp = DateTime.now();
      final params = {'id': '123'};
      final routeInfo = GoRouteInfo(
        location: '/user/123',
        path: '/user/:id',
        timestamp: timestamp,
        params: params,
      );

      // Act
      final map = routeInfo.toMap();

      // Assert
      expect(map['location'], '/user/123');
      expect(map['path'], '/user/:id');
      expect(map['timestamp'], timestamp.toIso8601String());
      expect(map['params'], params);
    });

    test('should convert to Map with null params', () {
      // Arrange
      final timestamp = DateTime.now();
      final routeInfo = GoRouteInfo(
        location: '/home',
        path: '/home',
        timestamp: timestamp,
      );

      // Act
      final map = routeInfo.toMap();

      // Assert
      expect(map['params'], isNull);
    });

    test('should have correct toString representation', () {
      // Arrange
      final timestamp = DateTime.now();
      final routeInfo = GoRouteInfo(
        location: '/home',
        path: '/home',
        timestamp: timestamp,
      );

      // Act
      final string = routeInfo.toString();

      // Assert
      expect(string, contains('GoRouteInfo'));
      expect(string, contains('location: /home'));
      expect(string, contains('path: /home'));
      expect(string, contains('timestamp: $timestamp'));
    });

    test('timestamp should be in ISO8601 format in toMap', () {
      // Arrange
      final timestamp = DateTime.parse('2026-01-10T12:00:00.000Z');
      final routeInfo = GoRouteInfo(
        location: '/home',
        path: '/home',
        timestamp: timestamp,
      );

      // Act
      final map = routeInfo.toMap();

      // Assert
      expect(map['timestamp'], '2026-01-10T12:00:00.000Z');
    });
  });
}
