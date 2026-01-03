import 'package:flutter/material.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/services/installation_status_service.dart';

/// Page for displaying and managing installation steps
class InstallationStepsPage extends StatefulWidget {
  final String installationId;

  const InstallationStepsPage({
    super.key,
    required this.installationId,
  });

  @override
  State<InstallationStepsPage> createState() => _InstallationStepsPageState();
}

class _InstallationStepsPageState extends State<InstallationStepsPage> {
  final _statusService = getIt<InstallationStatusService>();

  // Sample installation steps - replace with actual data
  late final List<InstallationStep> _steps;

  @override
  void initState() {
    super.initState();

    // Initialize steps
    _steps = [
      InstallationStep(
        id: '1',
        title: 'Prepare Installation Site',
        description: 'Clear the area and ensure proper ventilation',
        isCompleted: false,
      ),
      InstallationStep(
        id: '2',
        title: 'Unpack Equipment',
        description: 'Carefully remove all items from packaging',
        isCompleted: false,
      ),
      InstallationStep(
        id: '3',
        title: 'Mount Main Unit',
        description: 'Attach the main unit using provided brackets',
        isCompleted: false,
      ),
      InstallationStep(
        id: '4',
        title: 'Connect Power Supply',
        description: 'Connect power cables according to manual',
        isCompleted: false,
      ),
      InstallationStep(
        id: '5',
        title: 'System Configuration',
        description: 'Configure system settings and test functionality',
        isCompleted: false,
      ),
      InstallationStep(
        id: '6',
        title: 'Final Verification',
        description: 'Verify all connections and run diagnostics',
        isCompleted: false,
      ),
    ];

    // Load saved step completion state
    _loadCompletedSteps();
  }

  void _loadCompletedSteps() {
    final completedStepIds = _statusService.getCompletedSteps();
    setState(() {
      for (var step in _steps) {
        step.isCompleted = completedStepIds.contains(step.id);
      }
    });
  }

  int get _completedSteps => _steps.where((s) => s.isCompleted).length;
  double get _progress => _steps.isEmpty ? 0 : _completedSteps / _steps.length;

  void _toggleStep(int index) async {
    final step = _steps[index];
    final newState = !step.isCompleted;

    setState(() {
      step.isCompleted = newState;
    });

    // Save to shared preferences
    if (newState) {
      await _statusService.markStepCompleted(step.id);
    } else {
      await _statusService.markStepIncomplete(step.id);
    }

    // If all steps completed, show completion dialog
    if (_completedSteps == _steps.length) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Installation Complete'),
        content: const Text(
          'All installation steps have been completed. Would you like to transition to Maintenance Mode?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not Yet'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _statusService.completeInstallation();
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Complete Installation'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installation Steps'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange.withValues(alpha: 0.1),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '$_completedSteps / ${_steps.length}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                  minHeight: 8,
                ),
              ],
            ),
          ),

          // Steps list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final step = _steps[index];
                return _StepCard(
                  step: step,
                  stepNumber: index + 1,
                  onToggle: () => _toggleStep(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InstallationStep {
  final String id;
  final String title;
  final String description;
  bool isCompleted;

  InstallationStep({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}

class _StepCard extends StatelessWidget {
  final InstallationStep step;
  final int stepNumber;
  final VoidCallback onToggle;

  const _StepCard({
    required this.step,
    required this.stepNumber,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: step.isCompleted ? 1 : 2,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number or checkmark
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: step.isCompleted
                      ? Colors.green
                      : Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: step.isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        )
                      : Text(
                          '$stepNumber',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Step content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: step.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            decoration: step.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                  ],
                ),
              ),

              // Checkbox
              Checkbox(
                value: step.isCompleted,
                onChanged: (_) => onToggle(),
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
