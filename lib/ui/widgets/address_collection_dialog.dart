import 'package:flutter/material.dart';

// TODO: Removed - Address collection depends on userProfileProvider which was removed
// Placeholder dialog
class AddressCollectionDialog extends StatelessWidget {
  final VoidCallback? onAddressSaved;
  final bool dismissible;

  const AddressCollectionDialog({
    super.key,
    this.onAddressSaved,
    this.dismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Address Collection'),
      content: const Text('Address collection functionality has been removed'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
