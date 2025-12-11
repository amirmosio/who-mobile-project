import 'legal_document_model.dart';

/// Response model for current legal documents endpoint
class CurrentLegalDocumentsResponse {
  final LegalDocumentModel? termsOfService;
  final LegalDocumentModel? privacyPolicy;
  final LegalDocumentModel? cookiePolicy;
  final LegalDocumentModel? gdprConsent;

  CurrentLegalDocumentsResponse({
    this.termsOfService,
    this.privacyPolicy,
    this.cookiePolicy,
    this.gdprConsent,
  });

  factory CurrentLegalDocumentsResponse.fromJson(Map<String, dynamic> json) {
    return CurrentLegalDocumentsResponse(
      termsOfService: json['terms_of_service'] != null
          ? LegalDocumentModel.fromJson(
              json['terms_of_service'] as Map<String, dynamic>,
            )
          : null,
      privacyPolicy: json['privacy_policy'] != null
          ? LegalDocumentModel.fromJson(
              json['privacy_policy'] as Map<String, dynamic>,
            )
          : null,
      cookiePolicy: json['cookie_policy'] != null
          ? LegalDocumentModel.fromJson(
              json['cookie_policy'] as Map<String, dynamic>,
            )
          : null,
      gdprConsent: json['gdpr_consent'] != null
          ? LegalDocumentModel.fromJson(
              json['gdpr_consent'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'terms_of_service': termsOfService?.toJson(),
      'privacy_policy': privacyPolicy?.toJson(),
      'cookie_policy': cookiePolicy?.toJson(),
      'gdpr_consent': gdprConsent?.toJson(),
    };
  }
}
