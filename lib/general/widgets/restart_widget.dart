import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;
  static BuildContext? context;

  const RestartWidget({super.key, required this.child});

  static void restartApp() {
    final _RestartWidgetState? state = context!
        .findAncestorStateOfType<_RestartWidgetState>();
    state?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: ProviderScope(
        child: Builder(
          builder: (context) {
            RestartWidget.context = context;
            return widget.child;
          },
        ),
      ),
    );
  }
}
