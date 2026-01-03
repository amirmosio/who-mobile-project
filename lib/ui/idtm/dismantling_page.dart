import 'package:flutter/material.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';

/// Page for managing dismantling/repacking steps
class DismantlingPage extends StatefulWidget {
  final String installationId;

  const DismantlingPage({
    super.key,
    required this.installationId,
  });

  @override
  State<DismantlingPage> createState() => _DismantlingPageState();
}

class _DismantlingPageState extends State<DismantlingPage> {
  final _storageManager = getIt<StorageManager>();

  // Sample dismantling steps - reverse of installation
  late final List<DismantlingStep> _steps;

  @override
  void initState() {
    super.initState();

    // Initialize steps
    _steps = [
      DismantlingStep(
        id: 'd1',
        title: 'System Shutdown',
        description: 'Safely shut down the system and disconnect power',
        isCompleted: false,
      ),
      DismantlingStep(
        id: 'd2',
        title: 'Disconnect Cables',
        description: 'Carefully disconnect all cables and connections',
        isCompleted: false,
      ),
      DismantlingStep(
        id: 'd3',
        title: 'Remove Main Unit',
        description: 'Detach and remove the main unit from mounting',
        isCompleted: false,
      ),
      DismantlingStep(
        id: 'd4',
        title: 'Inspect Components',
        description: 'Check all components for damage before packing',
        isCompleted: false,
      ),
      DismantlingStep(
        id: 'd5',
        title: 'Pack Equipment',
        description: 'Carefully pack all items in original packaging',
        isCompleted: false,
      ),
      DismantlingStep(
        id: 'd6',
        title: 'Final Checklist',
        description: 'Verify all items packed and site cleaned',
        isCompleted: false,
      ),
    ];

    // Load saved step completion state
    _loadCompletedSteps();
  }

  void _loadCompletedSteps() {
    final completedStepIds = _storageManager.getCompletedDismantlingSteps();
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
      await _storageManager.markDismantlingStepCompleted(step.id);
    } else {
      await _storageManager.markDismantlingStepIncomplete(step.id);
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
        title: const Text('Dismantling Complete'),
        content: const Text(
          'All dismantling steps have been completed. This will reset the installation status.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not Yet'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _storageManager.completeDismantling();
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Complete Dismantling'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dismantling'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Warning banner
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dismantling in Progress',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Follow each step carefully to ensure safe removal',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red.withValues(alpha: 0.05),
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
                            color: Colors.red,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
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

class DismantlingStep {
  final String id;
  final String title;
  final String description;
  bool isCompleted;

  DismantlingStep({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}

class _StepCard extends StatelessWidget {
  final DismantlingStep step;
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
                      : Colors.red.withValues(alpha: 0.1),
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
                                    color: Colors.red,
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
