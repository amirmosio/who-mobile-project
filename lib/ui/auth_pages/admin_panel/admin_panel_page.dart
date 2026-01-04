import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/auth/admin_user.dart';
import 'package:who_mobile_project/providers/auth/admin_users_provider.dart';
import 'package:who_mobile_project/providers/auth/auth_provider.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/auth/role_access_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/ui/auth_pages/admin_panel/widgets/admin_list_item.dart';
import 'package:who_mobile_project/ui/auth_pages/admin_panel/widgets/create_admin_dialog.dart';

/// Admin panel page for managing admin users
/// Only accessible by super admin
class AdminPanelPage extends ConsumerStatefulWidget {
  const AdminPanelPage({super.key});

  @override
  ConsumerState<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends ConsumerState<AdminPanelPage> {
  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = ref.watch(isSuperAdminProvider);
    final currentUser = ref.watch(currentUserProvider);
    final adminUsersAsync = ref.watch(adminUsersStreamProvider);

    // Check access permission
    if (!isSuperAdmin) {
      return _buildAccessDenied();
    }

    // Listen for auth state changes (logout, etc)
    ref.listen(authProvider, (previous, next) {
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
      body: adminUsersAsync.when(
        data: (admins) => _buildAdminList(admins, currentUser.value?.uid),
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
        onPressed: () => context.go(YRRoutes.dashBoard),
      ),
      title: Text(
        'Admin Management',
        style: AppTextStyles.headingH2.copyWith(
          color: GVColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, size: 24),
          color: GVColors.black,
          onPressed: _handleLogout,
          tooltip: 'Logout',
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

  Widget _buildAdminList(List<AdminUser> admins, String? currentUserId) {
    if (admins.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      itemCount: admins.length,
      itemBuilder: (context, index) {
        final admin = admins[index];
        return AdminListItem(
          admin: admin,
          isCurrentUser: admin.uid == currentUserId,
          onToggleStatus:
              admin.isSuperAdmin ? null : () => _toggleAdminStatus(admin),
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
                Icons.people_outline,
                size: 40,
                color: GVColors.darkGrey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Admin Users',
              style: AppTextStyles.headingH2.copyWith(
                color: GVColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first admin user',
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
              'Error Loading Admins',
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
              onPressed: () => ref.invalidate(adminUsersStreamProvider),
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
                'Super Admin privileges are required to access this page.',
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
      onPressed: _showCreateAdminDialog,
      backgroundColor: GVColors.purpleAccent,
      foregroundColor: GVColors.white,
      icon: const Icon(Icons.person_add),
      label: const Text('Add Admin'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Future<void> _showCreateAdminDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CreateAdminDialog(),
    );
  }

  Future<void> _toggleAdminStatus(AdminUser admin) async {
    if (admin.isActive) {
      await ref.read(authProvider.notifier).deactivateAdmin(admin.uid);
    } else {
      await ref.read(authProvider.notifier).reactivateAdmin(admin.uid);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
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
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authProvider.notifier).signOut();
      if (mounted) {
        context.go(YRRoutes.dashBoard);
      }
    }
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
