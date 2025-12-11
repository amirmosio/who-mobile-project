/// Legal document model matching backend API
class LegalDocumentModel {
  final int id;
  final int documentType; // Document type ID (PositiveIntegerField)
  final String version; // Version number (e.g., '1.0', '2.0')
  final String title;
  final String content; // Full document content (can include HTML)
  final int? languageId; // Language ID from ForeignKey
  final String? languageCode; // Language code for convenience
  final DateTime? effectiveDate; // Date when this version becomes effective
  final bool isActive; // Whether this is the current active version
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LegalDocumentModel({
    required this.id,
    required this.documentType,
    required this.version,
    required this.title,
    required this.content,
    this.languageId,
    this.languageCode,
    this.effectiveDate,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    // Handle language field - could be ID or object with code
    int? languageId;
    String? languageCode;
    if (json['language'] != null) {
      if (json['language'] is int) {
        languageId = json['language'] as int;
      } else if (json['language'] is Map<String, dynamic>) {
        languageId = json['language']['id'] as int?;
        languageCode = json['language']['code'] as String?;
      }
    }

    return LegalDocumentModel(
      id: json['id'] as int,
      documentType: json['document_type'] as int,
      version: json['version'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      languageId: languageId,
      languageCode: languageCode ?? json['language_code'] as String?,
      effectiveDate: json['effective_date'] != null
          ? DateTime.tryParse(json['effective_date'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': documentType,
      'version': version,
      'title': title,
      'content': content,
      'language': languageId,
      'language_code': languageCode,
      'effective_date': effectiveDate?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Check if this is a terms of service document
  /// document_type 0 = Terms of Service
  bool get isTermsOfService => documentType == 0;

  /// Check if this is a privacy policy document
  /// document_type 0 = Privacy Policy (or different type - adjust based on backend)
  bool get isPrivacyPolicy => documentType == 0;
}
