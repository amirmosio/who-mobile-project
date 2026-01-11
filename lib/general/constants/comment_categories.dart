/// Comment categories for the WHO Mobile app
/// Used to organize comments by operational phase
enum CommentCategory {
  /// Installation-related comments
  install,

  /// Maintenance-related comments
  maintenance,

  /// Disassembly-related comments
  disassemble,

  /// General comments that don't fit other categories
  general;

  /// Convert category to Firestore string value
  String toFirestoreValue() {
    switch (this) {
      case CommentCategory.install:
        return 'install';
      case CommentCategory.maintenance:
        return 'maintenance';
      case CommentCategory.disassemble:
        return 'disassemble';
      case CommentCategory.general:
        return 'general';
    }
  }

  /// Parse category from Firestore string value
  /// Returns general if value is null or unrecognized
  static CommentCategory fromFirestoreValue(String? value) {
    switch (value) {
      case 'install':
        return CommentCategory.install;
      case 'maintenance':
        return CommentCategory.maintenance;
      case 'disassemble':
        return CommentCategory.disassemble;
      case 'general':
      default:
        return CommentCategory.general;
    }
  }

  /// Get display name for the category
  String get displayName {
    switch (this) {
      case CommentCategory.install:
        return 'Installation';
      case CommentCategory.maintenance:
        return 'Maintenance';
      case CommentCategory.disassemble:
        return 'Disassembly';
      case CommentCategory.general:
        return 'General';
    }
  }
}
