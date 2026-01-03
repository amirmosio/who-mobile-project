import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';

/// Page displaying the packing list with visual recognition
class PackingListPage extends StatelessWidget {
  const PackingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packing List'),
        backgroundColor: BZColors.bronzeDark,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card
          Card(
            color: BZColors.bronzeDark.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.inventory_2,
                    size: 40,
                    color: BZColors.bronzeDark,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Equipment Checklist',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Verify all items before installation',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sample packing list items
          _PackingListItem(
            itemName: 'Main Unit',
            quantity: 1,
            isChecked: false,
            imageUrl: null,
          ),
          _PackingListItem(
            itemName: 'Power Supply',
            quantity: 1,
            isChecked: false,
            imageUrl: null,
          ),
          _PackingListItem(
            itemName: 'Mounting Brackets',
            quantity: 4,
            isChecked: false,
            imageUrl: null,
          ),
          _PackingListItem(
            itemName: 'Connection Cables',
            quantity: 2,
            isChecked: false,
            imageUrl: null,
          ),
          _PackingListItem(
            itemName: 'Tools Kit',
            quantity: 1,
            isChecked: false,
            imageUrl: null,
          ),
          _PackingListItem(
            itemName: 'Installation Manual',
            quantity: 1,
            isChecked: false,
            imageUrl: null,
          ),

          const SizedBox(height: 24),

          // Action buttons
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement visual recognition
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Visual recognition feature coming soon'),
                ),
              );
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Scan with Camera'),
            style: ElevatedButton.styleFrom(
              backgroundColor: BZColors.bronzeDark,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackingListItem extends StatefulWidget {
  final String itemName;
  final int quantity;
  final bool isChecked;
  final String? imageUrl;

  const _PackingListItem({
    required this.itemName,
    required this.quantity,
    required this.isChecked,
    this.imageUrl,
  });

  @override
  State<_PackingListItem> createState() => _PackingListItemState();
}

class _PackingListItemState extends State<_PackingListItem> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: _isChecked,
        onChanged: (value) {
          setState(() {
            _isChecked = value ?? false;
          });
        },
        title: Text(
          widget.itemName,
          style: TextStyle(
            decoration: _isChecked ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('Quantity: ${widget.quantity}'),
        secondary: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.grey,
                ),
        ),
        activeColor: BZColors.bronzeDark,
      ),
    );
  }
}
