import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/data/idtm_packing_list_data.dart';
import 'package:who_mobile_project/models/packing_list_item.dart';
import 'dart:io';

/// Page displaying the IDTM packing list with visual recognition
class PackingListPage extends StatefulWidget {
  const PackingListPage({super.key});

  @override
  State<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<PackingListPage> {
  final Map<String, bool> _checkedItems = {};
  final Map<String, bool> _expandedItems = {};
  late List<PackingListItem> _packingList;
  bool _isLoading = true;
  bool _isScanning = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _packingList = IdtmPackingListData.getPackingList();
    _loadSavedState();
  }

  /// Load saved checkbox states from SharedPreferences
  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      for (var item in _packingList) {
        // Load checked state
        _checkedItems[item.id] = prefs.getBool('checked_${item.id}') ?? false;
        // Load expanded state for main items
        if (item.level == 1) {
          _expandedItems[item.id] = prefs.getBool('expanded_${item.id}') ?? false;
        }
      }
      _isLoading = false;
    });
  }

  /// Save checkbox state to SharedPreferences
  Future<void> _saveCheckedState(String itemId, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checked_$itemId', value);
  }

  /// Save expanded state to SharedPreferences
  Future<void> _saveExpandedState(String itemId, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('expanded_$itemId', value);
  }

  /// Count only main items (Level 1) that are checked
  int get _totalItems => IdtmPackingListData.getMainItems().length;

  int get _checkedCount {
    return IdtmPackingListData.getMainItems()
        .where((item) => _checkedItems[item.id] == true)
        .length;
  }

  /// Handle parent checkbox change - also checks/unchecks all children
  void _handleParentCheckChanged(String parentId, bool? value) {
    setState(() {
      _checkedItems[parentId] = value ?? false;

      // Also check/uncheck all sub-items
      final subItems = IdtmPackingListData.getSubItems(parentId);
      for (var subItem in subItems) {
        _checkedItems[subItem.id] = value ?? false;
        _saveCheckedState(subItem.id, value ?? false);
      }
    });

    _saveCheckedState(parentId, value ?? false);
  }

  /// Handle sub-item checkbox change - may update parent state
  void _handleSubItemCheckChanged(String parentId, String subItemId, bool? value) {
    setState(() {
      _checkedItems[subItemId] = value ?? false;

      // Check if all sub-items are checked
      final subItems = IdtmPackingListData.getSubItems(parentId);
      final allSubItemsChecked = subItems.every((item) => _checkedItems[item.id] == true);

      // Update parent checkbox state
      if (allSubItemsChecked) {
        _checkedItems[parentId] = true;
        _saveCheckedState(parentId, true);
      } else if (value == false) {
        // If unchecking a sub-item, uncheck parent too
        _checkedItems[parentId] = false;
        _saveCheckedState(parentId, false);
      }
    });

    _saveCheckedState(subItemId, value ?? false);
  }

  /// Show dialog to select which item to scan
  Future<PackingListItem?> _showItemSelectionDialog() async {
    final mainItems = IdtmPackingListData.getMainItems();

    return showDialog<PackingListItem>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Item to Scan'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mainItems.length,
            itemBuilder: (context, index) {
              final item = mainItems[index];
              final isChecked = _checkedItems[item.id] ?? false;

              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isChecked ? Colors.green[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isChecked ? Icons.check_circle : Icons.inventory_2_outlined,
                    color: isChecked ? Colors.green : Colors.grey[600],
                  ),
                ),
                title: Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  item.dimensions,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.camera_alt, size: 20),
                onTap: () => Navigator.of(context).pop(item),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Scan item with camera and verify with API (mocked for now)
  Future<void> _scanItemWithCamera() async {
    try {
      setState(() {
        _isScanning = true;
      });

      // Step 1: Let user select which item they're scanning
      final selectedItem = await _showItemSelectionDialog();

      if (selectedItem == null) {
        setState(() {
          _isScanning = false;
        });
        return;
      }

      // Step 2: Show options: Camera or Gallery
      if (!mounted) return;
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Scan ${selectedItem.name}'),
          content: const Text('Choose image source:'),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );

      if (source == null) {
        setState(() {
          _isScanning = false;
        });
        return;
      }

      // Pick image from selected source
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image == null) {
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
        }
        return;
      }

      // Show processing dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Analyzing image...'),
              ],
            ),
          ),
        );
      }

      // Mock API call - simulate network delay
      final result = await _mockApiVerifyItem(image.path);

      // Close processing dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show result dialog and handle auto-checking
      if (mounted) {
        await _showScanResultDialog(result, image.path, selectedItem);
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  /// Mock API call - Always returns true for now
  /// TODO: Replace with actual API endpoint when available
  Future<bool> _mockApiVerifyItem(String imagePath) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock: Always return true for now
    // In production, this would call:
    // final response = await dio.post('/api/verify-item', data: FormData.fromMap({
    //   'image': await MultipartFile.fromFile(imagePath),
    // }));
    // return response.data['verified'] == true;

    return true; // Mock: Always verified
  }

  /// Show scan result dialog with image preview
  Future<void> _showScanResultDialog(
    bool verified,
    String imagePath,
    PackingListItem selectedItem,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              verified ? Icons.check_circle : Icons.cancel,
              color: verified ? Colors.green : Colors.red,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                verified ? 'Item Verified!' : 'Item Not Found',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selected item info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedItem.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            selectedItem.dimensions,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Image preview
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                verified
                    ? 'The item has been successfully verified and matched with the packing list.'
                    : 'The item could not be verified. Please try again or check manually.',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              if (verified) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This item will be automatically checked off.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (verified)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Auto-check the verified item
                _handleParentCheckChanged(selectedItem.id, true);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✓ ${selectedItem.name} verified and checked!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Check Item'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('IDTM Packing List'),
          backgroundColor: BZColors.bronzeDark,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final mainItems = IdtmPackingListData.getMainItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('IDTM Packing List'),
        backgroundColor: BZColors.bronzeDark,
        foregroundColor: Colors.white,
        actions: [
          // Progress indicator
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '$_checkedCount/$_totalItems',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header card
          Card(
            margin: const EdgeInsets.all(16),
            color: BZColors.bronzeDark.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
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
                  const SizedBox(height: 12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _totalItems > 0 ? _checkedCount / _totalItems : 0,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        BZColors.bronzeDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Weight: ${IdtmPackingListData.getTotalWeight().toStringAsFixed(0)} kg',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Packing list items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mainItems.length,
              itemBuilder: (context, index) {
                final item = mainItems[index];
                final subItems = IdtmPackingListData.getSubItems(item.id);
                final isExpanded = _expandedItems[item.id] ?? false;

                return _PackingListCard(
                  item: item,
                  subItems: subItems,
                  isChecked: _checkedItems[item.id] ?? false,
                  isExpanded: isExpanded,
                  onCheckChanged: (value) {
                    _handleParentCheckChanged(item.id, value);
                  },
                  onExpandChanged: () {
                    setState(() {
                      _expandedItems[item.id] = !isExpanded;
                    });
                    _saveExpandedState(item.id, !isExpanded);
                  },
                  onSubItemCheckChanged: (subItemId, value) {
                    _handleSubItemCheckChanged(item.id, subItemId, value);
                  },
                  getSubItemChecked: (subItemId) =>
                      _checkedItems[subItemId] ?? false,
                );
              },
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: _isScanning ? null : _scanItemWithCamera,
                  icon: _isScanning
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.camera_alt),
                  label: Text(_isScanning ? 'Scanning...' : 'Scan with Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BZColors.bronzeDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    // Show confirmation dialog
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Checklist'),
                        content: const Text(
                          'Are you sure you want to reset all checkboxes? This cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      // Clear all checkboxes and save to preferences
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        for (var key in _checkedItems.keys) {
                          _checkedItems[key] = false;
                          prefs.setBool('checked_$key', false);
                        }
                      });

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checklist reset successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Checklist'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BZColors.bronzeDark,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PackingListCard extends StatelessWidget {
  final PackingListItem item;
  final List<PackingListItem> subItems;
  final bool isChecked;
  final bool isExpanded;
  final ValueChanged<bool?> onCheckChanged;
  final VoidCallback onExpandChanged;
  final Function(String, bool?) onSubItemCheckChanged;
  final bool Function(String) getSubItemChecked;

  const _PackingListCard({
    required this.item,
    required this.subItems,
    required this.isChecked,
    required this.isExpanded,
    required this.onCheckChanged,
    required this.onExpandChanged,
    required this.onSubItemCheckChanged,
    required this.getSubItemChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Column(
        children: [
          // Main item
          InkWell(
            onTap: subItems.isNotEmpty ? onExpandChanged : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: isChecked,
                    onChanged: onCheckChanged,
                    activeColor: BZColors.bronzeDark,
                  ),
                  const SizedBox(width: 12),

                  // Image placeholder
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: item.imageAsset != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.imageAsset!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.inventory_2_outlined,
                                  color: Colors.grey,
                                  size: 32,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.grey,
                            size: 32,
                          ),
                  ),
                  const SizedBox(width: 12),

                  // Item details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            decoration:
                                isChecked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qty: ${item.quantity} • ${item.dimensions}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        if (item.weight != null && item.weight!.isNotEmpty)
                          Text(
                            'Weight: ${item.weight}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        if (item.description != null)
                          Text(
                            item.description!,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // Expand icon for items with sub-items
                  if (subItems.isNotEmpty)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: BZColors.bronzeDark,
                    ),
                ],
              ),
            ),
          ),

          // Sub-items (expandable)
          if (subItems.isNotEmpty && isExpanded)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                children: subItems.map((subItem) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: CheckboxListTile(
                      value: getSubItemChecked(subItem.id),
                      onChanged: (value) =>
                          onSubItemCheckChanged(subItem.id, value),
                      title: Text(
                        subItem.name,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: getSubItemChecked(subItem.id)
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (subItem.quantity > 0)
                            Text(
                              'Qty: ${subItem.quantity}${subItem.dimensions.isNotEmpty ? ' • ${subItem.dimensions}' : ''}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          if (subItem.description != null)
                            Text(
                              subItem.description!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                      dense: true,
                      activeColor: BZColors.bronzeDark,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
