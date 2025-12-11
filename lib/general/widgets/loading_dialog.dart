import 'package:flutter/material.dart';
import 'package:who_mobile_project/general/widgets/my_loading_gif.dart';
import 'package:uuid/uuid.dart';

/// A comprehensive loading dialog manager that handles multiple concurrent loading states
///
/// This class uses a stack-based approach with unique IDs to ensure the correct dialog
/// is dismissed even when multiple loading operations occur simultaneously.
///
/// The system uses BuildContext references to ensure the exact dialog is dismissed,
/// preventing issues where new pages pushed on top would be popped instead.
///
/// Example usage:
/// ```dart
/// // Show loading
/// final loadingId = LoadingDialogManager.show(context);
///
/// // Do async work
/// await someAsyncOperation();
///
/// // Hide the specific loading dialog
/// LoadingDialogManager.hide(context, loadingId);
/// ```
class LoadingDialogManager {
  static final Map<String, VoidCallback> _activeDialogs = {};
  static const _uuid = Uuid();

  /// Shows a loading dialog and returns a unique ID for this dialog
  ///
  /// The ID should be stored and used later to hide the correct dialog.
  ///
  /// [context] - The BuildContext to show the dialog in
  /// [barrierDismissible] - Whether the dialog can be dismissed by tapping outside (default: false)
  ///
  /// Returns a unique String ID that identifies this specific loading dialog
  static String show(BuildContext context, {bool barrierDismissible = false}) {
    final String dialogId = _uuid.v4();
    BuildContext? dialogContext;

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      builder: (BuildContext ctx) {
        // Store the dialog's BuildContext
        dialogContext = ctx;

        return PopScope(
          canPop: barrierDismissible,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              _activeDialogs.remove(dialogId);
            }
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: _LoadingDialogContent(dialogId: dialogId),
          ),
        );
      },
    ).then((_) {
      // Clean up when dialog is dismissed
      _activeDialogs.remove(dialogId);
    });

    // Store a callback that will dismiss this specific dialog
    // This callback captures the dialog's BuildContext and uses it for dismissal
    _activeDialogs[dialogId] = () {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.of(dialogContext!, rootNavigator: true).pop();
      }
    };

    return dialogId;
  }

  /// Hides the loading dialog with the specified ID
  ///
  /// This ensures that only the correct dialog is dismissed, even if:
  /// - Multiple loading dialogs are active
  /// - New pages have been pushed on top of the dialog
  /// - The navigation stack has changed
  ///
  /// The method uses a stored dismissal callback that references the exact
  /// dialog context, ensuring precise dismissal regardless of navigation changes.
  ///
  /// [context] - The original BuildContext (not used, kept for API compatibility)
  /// [dialogId] - The unique ID returned from the show() method
  static void hide(BuildContext context, String dialogId) {
    final dismissCallback = _activeDialogs[dialogId];

    if (dismissCallback != null) {
      try {
        dismissCallback();
      } catch (e) {
        debugPrint(
          'LoadingDialogManager: Error dismissing dialog $dialogId: $e',
        );
      } finally {
        _activeDialogs.remove(dialogId);
      }
    }
  }

  /// Returns the number of currently active loading dialogs
  static int get activeDialogCount => _activeDialogs.length;

  /// Checks if a specific dialog is still active
  static bool isActive(String dialogId) => _activeDialogs.containsKey(dialogId);

  /// Checks if any loading dialog is currently active
  static bool get hasActiveDialogs => _activeDialogs.isNotEmpty;
}

/// Internal widget that displays the loading animation
class _LoadingDialogContent extends StatelessWidget {
  final String dialogId;

  const _LoadingDialogContent({required this.dialogId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: MyLoadingGifWidget());
  }
}
