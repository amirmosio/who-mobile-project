import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/idtm/idtm_facility.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';
import 'package:who_mobile_project/providers/auth/role_access_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/idtm/facilities_provider.dart';
import 'package:who_mobile_project/providers/maintenance/alert_template_provider.dart';

/// Predefined maintenance alert templates based on PMI/CMI tasks
class MaintenanceAlertTemplate {
  final String taskId;
  final String title;
  final String description;
  final int intervalHours;
  final AlertPriority priority;

  const MaintenanceAlertTemplate({
    required this.taskId,
    required this.title,
    required this.description,
    required this.intervalHours,
    required this.priority,
  });
}

/// Default maintenance alert templates for initialization
const List<MaintenanceAlertTemplate> defaultMaintenanceAlerts = [
  // Daily tasks
  MaintenanceAlertTemplate(
    taskId: 'pmi-2-daily-inspection',
    title: 'PMI 2: Daily Inspection',
    description:
        'Perform daily inspection: check zippers, sweep groundsheet, inspect pegs, ensure ventilation.',
    intervalHours: 24,
    priority: AlertPriority.high,
  ),

  // Weekly tasks
  MaintenanceAlertTemplate(
    taskId: 'pmi-8-storage-conditions',
    title: 'PMI 8: Storage Conditions Check',
    description:
        'Weekly check: Monitor temperature (18-21°C), humidity (60-65%), air circulation, and vermin control.',
    intervalHours: 168,
    priority: AlertPriority.high,
  ),

  // Weather-related (frequent during adverse conditions)
  MaintenanceAlertTemplate(
    taskId: 'pmi-3-weather-conditions',
    title: 'PMI 3: Weather Conditions Check',
    description:
        'Check for adverse weather: wind above 40 km/h, rain drainage, snow/ice accumulation, temperature changes.',
    intervalHours: 8,
    priority: AlertPriority.critical,
  ),

  // Before storage tasks (monthly reminder)
  MaintenanceAlertTemplate(
    taskId: 'pmi-5-textile-maintenance',
    title: 'PMI 5: Textile Parts Maintenance',
    description:
        'Inspect all textile parts for cuts, holes, abrasions, tears, and open seams. Check fabric for repair needs.',
    intervalHours: 720, // Monthly
    priority: AlertPriority.medium,
  ),
  MaintenanceAlertTemplate(
    taskId: 'pmi-6-cleaning',
    title: 'PMI 6: Cleaning Reminder',
    description:
        'Clean all components using water-based detergent. Rinse thoroughly with clean water.',
    intervalHours: 720, // Monthly
    priority: AlertPriority.medium,
  ),
];

/// Page for Super Admin to initialize maintenance alert templates for a facility
class MaintenanceAlertsInitializerPage extends ConsumerStatefulWidget {
  const MaintenanceAlertsInitializerPage({super.key});

  @override
  ConsumerState<MaintenanceAlertsInitializerPage> createState() =>
      _MaintenanceAlertsInitializerPageState();
}

class _MaintenanceAlertsInitializerPageState
    extends ConsumerState<MaintenanceAlertsInitializerPage> {
  IdtmFacility? _selectedFacility;
  final Set<String> _selectedTemplates = {};
  bool _isCreating = false;
  int _createdCount = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Select all templates by default
    _selectedTemplates.addAll(defaultMaintenanceAlerts.map((t) => t.taskId));

    // Load facilities
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(facilitiesProvider.notifier).loadFacilities();
    });
  }

  Future<void> _createSelectedAlerts() async {
    if (_selectedFacility == null) {
      setState(() => _errorMessage = 'Please select a facility first');
      return;
    }

    if (_selectedTemplates.isEmpty) {
      setState(() => _errorMessage = 'Please select at least one alert template');
      return;
    }

    setState(() {
      _isCreating = true;
      _createdCount = 0;
      _errorMessage = null;
    });

    final notifier = ref.read(alertTemplateProvider.notifier);
    int successCount = 0;

    for (final template in defaultMaintenanceAlerts) {
      if (!_selectedTemplates.contains(template.taskId)) continue;

      final result = await notifier.createTemplate(
        facilityId: _selectedFacility!.id,
        facilityName: _selectedFacility!.name,
        title: template.title,
        description: template.description,
        intervalHours: template.intervalHours,
        priority: template.priority,
        maintenanceTaskId: template.taskId,
        maintenanceTaskTitle: template.title,
      );

      if (result != null) {
        successCount++;
        setState(() => _createdCount = successCount);
      }
    }

    setState(() => _isCreating = false);

    if (successCount == _selectedTemplates.length) {
      _showSuccessDialog(successCount);
    } else {
      setState(() => _errorMessage =
          'Created $successCount of ${_selectedTemplates.length} alerts. Some failed.');
    }
  }

  void _showSuccessDialog(int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 12),
            Text('Success'),
          ],
        ),
        content: Text(
          'Successfully created $count maintenance alert templates for ${_selectedFacility!.name}.\n\n'
          'These alerts will be scheduled when installations enter the maintenance phase.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to admin page
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = ref.watch(isSuperAdminProvider);
    final facilitiesState = ref.watch(facilitiesProvider);

    // Listen for errors
    ref.listen(alertTemplateProvider, (previous, next) {
      if (next is BaseApiError) {
        setState(() => _errorMessage =
            next.exception.message ?? 'Failed to create template');
      }
    });

    if (!isSuperAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Super Admin access required'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Initialize Maintenance Alerts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This will create predefined maintenance alert templates for the selected facility. '
                      'Users will receive notifications at the specified intervals.',
                      style: AppTextStyles.bodyText.copyWith(
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Facility selector
            Text(
              'Select Facility',
              style: AppTextStyles.headingH3.copyWith(color: GVColors.black),
            ),
            const SizedBox(height: 12),
            _buildFacilitySelector(facilitiesState),
            const SizedBox(height: 24),

            // Templates selection
            Text(
              'Alert Templates to Create',
              style: AppTextStyles.headingH3.copyWith(color: GVColors.black),
            ),
            const SizedBox(height: 4),
            Text(
              'Select which maintenance alerts to initialize',
              style: AppTextStyles.subtitleText.copyWith(color: GVColors.darkGrey),
            ),
            const SizedBox(height: 12),

            // Select all / deselect all
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedTemplates.addAll(
                        defaultMaintenanceAlerts.map((t) => t.taskId),
                      );
                    });
                  },
                  icon: const Icon(Icons.select_all, size: 18),
                  label: const Text('Select All'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _selectedTemplates.clear());
                  },
                  icon: const Icon(Icons.deselect, size: 18),
                  label: const Text('Deselect All'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Template list
            ...defaultMaintenanceAlerts.map(_buildTemplateCard),
            const SizedBox(height: 24),

            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ),
              ),

            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCreating ? null : _createSelectedAlerts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GVColors.purpleAccent,
                  foregroundColor: GVColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isCreating
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('Creating... $_createdCount/${_selectedTemplates.length}'),
                        ],
                      )
                    : Text(
                        'Create ${_selectedTemplates.length} Alert Templates',
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: GVColors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitySelector(BaseApiState facilitiesState) {
    List<IdtmFacility> facilities = [];
    if (facilitiesState is BaseApiSuccess<List<IdtmFacility>>) {
      facilities = facilitiesState.data;
    }

    return Container(
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
            style: AppTextStyles.bodyText.copyWith(color: GVColors.darkGrey),
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
                style: AppTextStyles.bodyText.copyWith(color: GVColors.black),
              ),
            );
          }).toList(),
          onChanged: facilitiesState is BaseApiLoading
              ? null
              : (facility) {
                  setState(() {
                    _selectedFacility = facility;
                    _errorMessage = null;
                  });
                },
        ),
      ),
    );
  }

  Widget _buildTemplateCard(MaintenanceAlertTemplate template) {
    final isSelected = _selectedTemplates.contains(template.taskId);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? GVColors.purpleAccent : GVColors.lightBorderGrey,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedTemplates.remove(template.taskId);
            } else {
              _selectedTemplates.add(template.taskId);
            }
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedTemplates.add(template.taskId);
                    } else {
                      _selectedTemplates.remove(template.taskId);
                    }
                  });
                },
                activeColor: GVColors.purpleAccent,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            template.title,
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w600,
                              color: GVColors.black,
                            ),
                          ),
                        ),
                        _buildPriorityBadge(template.priority),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template.description,
                      style: AppTextStyles.subtitleText.copyWith(
                        color: GVColors.darkGrey,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: GVColors.darkGrey),
                        const SizedBox(width: 4),
                        Text(
                          _getIntervalDisplay(template.intervalHours),
                          style: AppTextStyles.subtitleText.copyWith(
                            color: GVColors.darkGrey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(AlertPriority priority) {
    Color color;
    switch (priority) {
      case AlertPriority.low:
        color = GVColors.greenSuccess;
      case AlertPriority.medium:
        color = GVColors.yellowWarning;
      case AlertPriority.high:
        color = GVColors.redError;
      case AlertPriority.critical:
        color = Colors.deepPurple;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.displayName,
        style: AppTextStyles.subtitleText.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getIntervalDisplay(int hours) {
    if (hours < 24) return 'Every $hours hours';
    if (hours == 24) return 'Daily';
    if (hours == 168) return 'Weekly';
    if (hours == 720) return 'Monthly';
    final days = hours ~/ 24;
    return 'Every $days days';
  }
}
