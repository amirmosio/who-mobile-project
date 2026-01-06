import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';
import 'package:who_mobile_project/providers/auth/role_access_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/maintenance/alert_template_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/ui/admin/widgets/alert_template_dialog.dart';
import 'package:who_mobile_project/ui/admin/widgets/alert_template_list_item.dart';

/// Alert templates management page for Super Admin
/// Allows creating, editing, and deleting maintenance alert templates
class AlertTemplatesPage extends ConsumerStatefulWidget {
  const AlertTemplatesPage({super.key});

  @override
  ConsumerState<AlertTemplatesPage> createState() => _AlertTemplatesPageState();
}

class _AlertTemplatesPageState extends ConsumerState<AlertTemplatesPage> {
  String? _selectedFacilityFilter;

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = ref.watch(isSuperAdminProvider);
    final templatesAsync = ref.watch(alertTemplatesStreamProvider);

    // Check access permission
    if (!isSuperAdmin) {
      return _buildAccessDenied();
    }

    // Listen for template operation results
    ref.listen(alertTemplateProvider, (previous, next) {
      if (next is BaseApiError) {
        _showSnackBar(
          next.exception.message ?? 'An error occurred',
          isError: true,
        );
      } else if (next is BaseApiOperationSuccess) {
        _showSnackBar(next.message ?? 'Operation completed');
      }
    });

    return Scaffold(
      backgroundColor: GVColors.white,
      appBar: _buildAppBar(),
      body: templatesAsync.when(
        data: (templates) => _buildTemplatesList(templates),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildError(error.toString()),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: GVColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        color: GVColors.black,
        onPressed: () => context.go(YRRoutes.adminPanel),
      ),
      title: Text(
        'Alert Templates',
        style: AppTextStyles.headingH2.copyWith(
          color: GVColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        // Initialize maintenance alerts button
        IconButton(
          icon: const Icon(Icons.playlist_add_check),
          color: GVColors.black,
          tooltip: 'Initialize Maintenance Alerts',
          onPressed: () => context.push(YRRoutes.initializeMaintenanceAlerts),
        ),
        PopupMenuButton<String?>(
          icon: Icon(
            Icons.filter_list,
            color: _selectedFacilityFilter != null
                ? GVColors.purpleAccent
                : GVColors.black,
          ),
          tooltip: 'Filter by facility',
          onSelected: (value) {
            setState(() {
              _selectedFacilityFilter = value;
            });
          },
          itemBuilder: (context) => [
            PopupMenuItem<String?>(
              value: null,
              child: Row(
                children: [
                  if (_selectedFacilityFilter == null)
                    Icon(Icons.check, color: GVColors.purpleAccent, size: 20)
                  else
                    const SizedBox(width: 20),
                  const SizedBox(width: 8),
                  const Text('All Facilities'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: GVColors.lightBorderGrey,
        ),
      ),
    );
  }

  Widget _buildTemplatesList(List<AlertTemplate> templates) {
    // Apply filter if set
    final filteredTemplates = _selectedFacilityFilter != null
        ? templates
            .where((t) => t.facilityId == _selectedFacilityFilter)
            .toList()
        : templates;

    if (filteredTemplates.isEmpty) {
      return _buildEmptyState();
    }

    // Group templates by facility
    final grouped = <String, List<AlertTemplate>>{};
    for (final template in filteredTemplates) {
      grouped.putIfAbsent(template.facilityName, () => []).add(template);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final facilityName = grouped.keys.elementAt(index);
        final facilityTemplates = grouped[facilityName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                facilityName,
                style: AppTextStyles.headingH3.copyWith(
                  color: GVColors.darkGrey,
                  fontSize: 14,
                ),
              ),
            ),
            ...facilityTemplates.map(
              (template) => AlertTemplateListItem(
                template: template,
                onEdit: () => _showEditDialog(template),
                onDelete: () => _confirmDelete(template),
                onToggleActive: () => _toggleActive(template),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: GVColors.lightGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.notifications_none,
                size: 40,
                color: GVColors.darkGrey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Alert Templates',
              style: AppTextStyles.headingH2.copyWith(
                color: GVColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first alert template for facility maintenance',
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: GVColors.redError,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Templates',
              style: AppTextStyles.headingH2.copyWith(
                color: GVColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.invalidate(alertTemplatesStreamProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: GVColors.purpleAccent,
                foregroundColor: GVColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessDenied() {
    return Scaffold(
      backgroundColor: GVColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: GVColors.redError,
              ),
              const SizedBox(height: 24),
              Text(
                'Access Denied',
                style: AppTextStyles.headingH1.copyWith(
                  color: GVColors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Super Admin privileges are required to manage alert templates.',
                style: AppTextStyles.bodyText.copyWith(
                  color: GVColors.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go(YRRoutes.dashBoard),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GVColors.purpleAccent,
                  foregroundColor: GVColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: Text(
                  'Go to Dashboard',
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: GVColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _showCreateDialog,
      backgroundColor: GVColors.purpleAccent,
      foregroundColor: GVColors.white,
      icon: const Icon(Icons.add_alert),
      label: const Text('Add Template'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Future<void> _showCreateDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertTemplateDialog(),
    );
  }

  Future<void> _showEditDialog(AlertTemplate template) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertTemplateDialog(template: template),
    );
  }

  Future<void> _confirmDelete(AlertTemplate template) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Template',
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${template.title}"? This action cannot be undone.',
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.darkGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: GVColors.redError,
              foregroundColor: GVColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref
          .read(alertTemplateProvider.notifier)
          .deleteTemplate(template.id);
    }
  }

  Future<void> _toggleActive(AlertTemplate template) async {
    await ref
        .read(alertTemplateProvider.notifier)
        .toggleTemplateActive(template.id, !template.isActive);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.smallText.copyWith(color: GVColors.white),
        ),
        backgroundColor: isError ? GVColors.redError : GVColors.greenSuccess,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
