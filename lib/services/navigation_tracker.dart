/// GoRouter-specific navigation tracker
class GoRouterTracker {
  static final GoRouterTracker _instance = GoRouterTracker._internal();
  factory GoRouterTracker() => _instance;
  GoRouterTracker._internal();

  final List<GoRouteInfo> _routeHistory = [];
  GoRouteInfo? _currentRoute;

  /// Maximum number of routes to keep in history
  static const int maxHistorySize = 20;

  /// Track a GoRouter navigation
  void trackNavigation(
    String location,
    String path, {
    Map<String, String>? params,
  }) {
    final routeInfo = GoRouteInfo(
      location: location,
      path: path,
      timestamp: DateTime.now(),
      params: params,
    );

    _currentRoute = routeInfo;

    // Add to history (avoid duplicates)
    if (_routeHistory.isEmpty || _routeHistory.first.location != location) {
      _routeHistory.insert(0, routeInfo);
    }

    // Limit history size
    if (_routeHistory.length > maxHistorySize) {
      _routeHistory.removeRange(maxHistorySize, _routeHistory.length);
    }
  }

  /// Get GoRouter navigation information
  Map<String, dynamic> getGoRouterInfo() {
    return {
      'current_route': _currentRoute?.path ?? 'Unknown',
      'route_history': _routeHistory.map((route) => route.path).toList(),
    };
  }

  /// Clear GoRouter history
  void clearHistory() {
    _routeHistory.clear();
    _currentRoute = null;
  }

  /// Get a summary of recent navigation for debugging
  String getNavigationSummary() {
    if (_routeHistory.isEmpty) {
      return 'No navigation history available';
    }

    final buffer = StringBuffer();
    buffer.writeln('Current Route: ${_currentRoute?.location ?? 'Unknown'}');
    buffer.writeln('Recent Navigation History:');

    for (int i = 0; i < _routeHistory.length && i < 5; i++) {
      final route = _routeHistory[i];
      buffer.writeln('  ${i + 1}. ${route.location} - ${route.timestamp}');
    }

    return buffer.toString();
  }
}

/// Information about a GoRouter route
class GoRouteInfo {
  final String location;
  final String path;
  final DateTime timestamp;
  final Map<String, String>? params;

  GoRouteInfo({
    required this.location,
    required this.path,
    required this.timestamp,
    this.params,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'path': path,
      'timestamp': timestamp.toIso8601String(),
      'params': params,
    };
  }

  @override
  String toString() {
    return 'GoRouteInfo(location: $location, path: $path, timestamp: $timestamp)';
  }
}
