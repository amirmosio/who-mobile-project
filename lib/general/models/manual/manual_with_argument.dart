import 'package:who_mobile_project/general/database/app_database.dart';

/// Combined model for Manual with its Argument (Topic)
/// Matches iOS CoreData relationship pattern
class ManualWithArgument {
  final ManualEntity manual;
  final ArgumentEntity? argument;

  ManualWithArgument({required this.manual, this.argument});

  /// Get the argument name for display
  String? get argumentName => argument?.name;

  /// Get the argument position for sorting
  int get argumentPosition => argument?.position ?? 0;

  /// Get the manual title for display
  String? get manualTitle => manual.title;

  /// Get the manual content for display
  String? get manualContent => manual.content;

  /// Get the manual summary for display
  String? get manualSummary => manual.summary;

  /// Get the manual position for sorting within argument
  int get manualPosition => manual.position;

  /// Check if manual is active
  bool get isActive => manual.isActive;

  /// Get manual ID
  int get manualId => manual.id;

  /// Get argument ID
  int get argumentId => manual.argumentId;

  /// Get license type ID
  int get licenseTypeId => manual.licenseTypeId;

  /// Get manual symbol for display
  String? get symbol => manual.symbol;

  /// Get manual URL if available
  String? get url => manual.url;

  /// Get manual note if available
  String? get note => manual.note;

  /// Get manual alt text if available
  String? get alt => manual.alt;

  /// Get image ID for display
  int? get imageId => manual.image;

  /// Get video ID if available
  int? get videoId => manual.video;

  /// Get creation datetime
  DateTime? get createdDatetime => manual.createdDatetime;

  /// Get modification datetime
  DateTime? get modifiedDatetime => manual.modifiedDatetime;
}
