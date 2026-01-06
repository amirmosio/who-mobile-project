import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/idtm/idtm_facility.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';
import 'package:who_mobile_project/general/models/maintenance_guide/maintenance_substep_model.dart';
import 'package:who_mobile_project/general/widgets/formfields/my_text_formfield.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/idtm/facilities_provider.dart';
import 'package:who_mobile_project/providers/maintenance/alert_template_provider.dart';
import 'package:who_mobile_project/providers/maintenance_guide/maintenance_provider.dart';

/// Dialog for creating or editing alert templates
class AlertTemplateDialog extends ConsumerStatefulWidget {
  final AlertTemplate? template;

  const AlertTemplateDialog({super.key, this.template});

  bool get isEditing => template != null;

  @override
  ConsumerState<AlertTemplateDialog> createState() =>
      _AlertTemplateDialogState();
}

class _AlertTemplateDialogState extends ConsumerState<AlertTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customIntervalController = TextEditingController();

  IdtmFacility? _selectedFacility;
  MaintenanceSubstepModel? _selectedMaintenanceTask;
  int _intervalHours = 24;
  AlertPriority _priority = AlertPriority.medium;
  bool _isLoading = false;
  bool _isCustomInterval = false;
  bool _hasInitializedMaintenanceTask = false;

  // Preset intervals + custom option (-1 represents custom)
  static const List<int> _intervalOptions = [1, 4, 8, 12, 24, 48, 168, 720, -1];

  // Min 1 hour, max 3 months (90 days = 2160 hours)
  static const int _minHours = 1;
  static const int _maxHours = 2160;

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _titleController.text = widget.template!.title;
      _descriptionController.text = widget.template!.description;
      _intervalHours = widget.template!.intervalHours;
      _priority = widget.template!.priority;

      // Check if it's a custom interval (not in preset list)
      if (!_intervalOptions.contains(_intervalHours)) {
        _isCustomInterval = true;
        _customIntervalController.text = _intervalHours.toString();
      }
    }

    // Load facilities
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(facilitiesProvider.notifier).loadFacilities();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _customIntervalController.dispose();
    super.dispose();
  }

  String _getIntervalLabel(int hours) {
    switch (hours) {
      case -1:
        return 'Custom...';
      case 1:
        return 'Every hour';
      case 4:
        return 'Every 4 hours';
      case 8:
        return 'Every 8 hours';
      case 12:
        return 'Every 12 hours';
      case 24:
        return 'Daily (24 hours)';
      case 48:
        return 'Every 2 days';
      case 168:
        return 'Weekly';
      case 720:
        return 'Monthly (30 days)';
      default:
        if (hours < 24) {
          return 'Every $hours hours';
        } else if (hours % 24 == 0) {
          final days = hours ~/ 24;
          return 'Every $days day${days == 1 ? '' : 's'}';
        } else {
          return 'Every $hours hours';
        }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (!widget.isEditing && _selectedFacility == null) {
      _showError('Please select a facility');
      return;
    }

    setState(() => _isLoading = true);

    bool success;
    if (widget.isEditing) {
      // Update existing template
      final updatedTemplate = widget.template!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        intervalHours: _intervalHours,
        priority: _priority,
        maintenanceTaskId: _selectedMaintenanceTask?.id,
        maintenanceTaskTitle: _selectedMaintenanceTask?.title,
      );
      success = await ref
          .read(alertTemplateProvider.notifier)
          .updateTemplate(updatedTemplate);
    } else {
      // Create new template
      final templateId = await ref
          .read(alertTemplateProvider.notifier)
          .createTemplate(
            facilityId: _selectedFacility!.id,
            facilityName: _selectedFacility!.name,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            intervalHours: _intervalHours,
            priority: _priority,
            maintenanceTaskId: _selectedMaintenanceTask?.id,
            maintenanceTaskTitle: _selectedMaintenanceTask?.title,
          );
      success = templateId != null;
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.smallText.copyWith(color: GVColors.white),
        ),
        backgroundColor: GVColors.redError,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider);
    final maintenanceDataAsync = ref.watch(maintenanceDataProvider);

    // Listen for errors
    ref.listen(alertTemplateProvider, (previous, next) {
      if (next is BaseApiError) {
        _showError(next.exception.message ?? 'Failed to save template');
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Facility selector (only for new templates)
                if (!widget.isEditing) ...[
                  _buildFacilitySelector(facilitiesState),
                  const SizedBox(height: 16),
                ],

                // Maintenance task selector (optional)
                _buildMaintenanceTaskSelector(maintenanceDataAsync),
                const SizedBox(height: 16),

                // Title field
                MyTextFormField(
                  controller: _titleController,
                  hintText: 'Enter alert title',
                  labelText: 'Title',
                  isMandatoryStartSign: true,
                  keyboardType: TextInputType.text,
                  validator: _validateTitle,
                ),
                const SizedBox(height: 16),

                // Description field
                MyTextFormField(
                  controller: _descriptionController,
                  hintText: 'Enter alert description',
                  labelText: 'Description',
                  isMandatoryStartSign: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: _validateDescription,
                ),
                const SizedBox(height: 16),

                // Interval selector
                _buildIntervalSelector(),
                const SizedBox(height: 16),

                // Priority selector
                _buildPrioritySelector(),
                const SizedBox(height: 24),

                // Action buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: GVColors.purpleAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            widget.isEditing ? Icons.edit_notifications : Icons.add_alert,
            color: GVColors.purpleAccent,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.isEditing ? 'Edit Template' : 'Create Template',
            style: AppTextStyles.headingH2.copyWith(
              color: GVColors.black,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: GVColors.darkGrey,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitySelector(BaseApiState facilitiesState) {
    List<IdtmFacility> facilities = [];
    if (facilitiesState is BaseApiSuccess<List<IdtmFacility>>) {
      facilities = facilitiesState.data;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Facility',
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              ' *',
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.redError,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: GVColors.lightBorderGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<IdtmFacility>(
              value: _selectedFacility,
              hint: Text(
                facilitiesState is BaseApiLoading
                    ? 'Loading facilities...'
                    : 'Select a facility',
                style: AppTextStyles.bodyText.copyWith(
                  color: GVColors.darkGrey,
                ),
              ),
              isExpanded: true,
              icon: facilitiesState is BaseApiLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.arrow_drop_down, color: GVColors.darkGrey),
              items: facilities.map((facility) {
                return DropdownMenuItem<IdtmFacility>(
                  value: facility,
                  child: Text(
                    facility.name,
                    style: AppTextStyles.bodyText.copyWith(
                      color: GVColors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: facilitiesState is BaseApiLoading
                  ? null
                  : (facility) {
                      setState(() {
                        _selectedFacility = facility;
                      });
                    },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceTaskSelector(
    AsyncValue<dynamic> maintenanceDataAsync,
  ) {
    // Extract all maintenance tasks from sections
    List<MaintenanceSubstepModel> allTasks = [];
    maintenanceDataAsync.whenData((data) {
      for (final section in data.sections) {
        if (section.steps != null) {
          allTasks.addAll(section.steps!);
        }
      }

      // Initialize selected task from template when editing (only once)
      if (!_hasInitializedMaintenanceTask &&
          widget.isEditing &&
          widget.template?.maintenanceTaskId != null) {
        _hasInitializedMaintenanceTask = true;
        final taskId = widget.template!.maintenanceTaskId;
        final matchingTask = allTasks.where((t) => t.id == taskId).firstOrNull;
        if (matchingTask != null) {
          // Use addPostFrameCallback to avoid setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedMaintenanceTask = matchingTask;
              });
            }
          });
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maintenance Task (Optional)',
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Link this alert to a specific maintenance task',
          style: AppTextStyles.subtitleText.copyWith(
            color: GVColors.darkGrey,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: GVColors.lightBorderGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<MaintenanceSubstepModel?>(
              value: _selectedMaintenanceTask,
              hint: Text(
                maintenanceDataAsync.isLoading
                    ? 'Loading tasks...'
                    : 'None (General Alert)',
                style: AppTextStyles.bodyText.copyWith(
                  color: GVColors.darkGrey,
                ),
              ),
              isExpanded: true,
              icon: maintenanceDataAsync.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.arrow_drop_down, color: GVColors.darkGrey),
              items: [
                // None option
                DropdownMenuItem<MaintenanceSubstepModel?>(
                  value: null,
                  child: Text(
                    'None (General Alert)',
                    style: AppTextStyles.bodyText.copyWith(
                      color: GVColors.darkGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                // All maintenance tasks
                ...allTasks.map((task) {
                  return DropdownMenuItem<MaintenanceSubstepModel>(
                    value: task,
                    child: Text(
                      task.title,
                      style: AppTextStyles.bodyText.copyWith(
                        color: GVColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ],
              onChanged: maintenanceDataAsync.isLoading
                  ? null
                  : (task) {
                      setState(() {
                        _selectedMaintenanceTask = task;
                        // Auto-fill title and description if task selected
                        if (task != null) {
                          _titleController.text = task.title;
                          _descriptionController.text =
                              task.purpose ?? task.content.firstOrNull ?? '';
                          // Set recommended interval based on task
                          _setRecommendedInterval(task.id);
                        }
                      });
                    },
            ),
          ),
        ),
      ],
    );
  }

  /// Set recommended interval based on task ID
  void _setRecommendedInterval(String taskId) {
    if (taskId.contains('daily')) {
      _intervalHours = 24;
      _isCustomInterval = false;
    } else if (taskId.contains('storage-conditions')) {
      _intervalHours = 168; // Weekly
      _isCustomInterval = false;
    } else if (taskId.contains('weather')) {
      _intervalHours = 4; // Check frequently
      _isCustomInterval = false;
    }
  }

  Widget _buildIntervalSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat Interval',
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: GVColors.lightBorderGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _isCustomInterval ? -1 : _intervalHours,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: GVColors.darkGrey),
              items: _intervalOptions.map((hours) {
                return DropdownMenuItem<int>(
                  value: hours,
                  child: Text(
                    _getIntervalLabel(hours),
                    style: AppTextStyles.bodyText.copyWith(
                      color: GVColors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (hours) {
                if (hours != null) {
                  setState(() {
                    if (hours == -1) {
                      _isCustomInterval = true;
                      _customIntervalController.text =
                          _intervalHours.toString();
                    } else {
                      _isCustomInterval = false;
                      _intervalHours = hours;
                    }
                  });
                }
              },
            ),
          ),
        ),
        // Custom interval input
        if (_isCustomInterval) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _customIntervalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter hours (1-2160)',
                    labelText: 'Custom Hours',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    final hours = int.tryParse(value);
                    if (hours != null &&
                        hours >= _minHours &&
                        hours <= _maxHours) {
                      setState(() {
                        _intervalHours = hours;
                      });
                    }
                  },
                  validator: (value) {
                    if (_isCustomInterval) {
                      final hours = int.tryParse(value ?? '');
                      if (hours == null) {
                        return 'Enter a valid number';
                      }
                      if (hours < _minHours) {
                        return 'Minimum $_minHours hour';
                      }
                      if (hours > _maxHours) {
                        return 'Maximum $_maxHours hours (3 months)';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'hours',
                style: AppTextStyles.bodyText.copyWith(
                  color: GVColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Min: 1 hour, Max: 2160 hours (3 months)',
            style: AppTextStyles.subtitleText.copyWith(
              color: GVColors.darkGrey,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: AlertPriority.values.map((priority) {
            final isSelected = _priority == priority;
            return ChoiceChip(
              label: Text(priority.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _priority = priority;
                  });
                }
              },
              selectedColor: _getPriorityColor(priority).withValues(alpha: 0.2),
              labelStyle: AppTextStyles.smallText.copyWith(
                color: isSelected
                    ? _getPriorityColor(priority)
                    : GVColors.darkGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? _getPriorityColor(priority)
                    : GVColors.lightBorderGrey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getPriorityColor(AlertPriority priority) {
    switch (priority) {
      case AlertPriority.low:
        return GVColors.greenSuccess;
      case AlertPriority.medium:
        return GVColors.yellowWarning;
      case AlertPriority.high:
        return GVColors.redError;
      case AlertPriority.critical:
        return Colors.deepPurple;
    }
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: GVColors.purpleAccent,
              side: BorderSide(color: GVColors.purpleAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonSmall.copyWith(
                color: GVColors.purpleAccent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: GVColors.purpleAccent,
              foregroundColor: GVColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              disabledBackgroundColor:
                  GVColors.purpleAccent.withValues(alpha: 0.6),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        GVColors.white,
                      ),
                    ),
                  )
                : Text(
                    widget.isEditing ? 'Update' : 'Create',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: GVColors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a title';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }
}
