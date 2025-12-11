import 'legal_document_model.dart';
import 'current_legal_documents_response.dart';

/// State model for legal documents provider
/// Contains all documents, current documents for a language, and accepted consents
class LegalDocumentState {
  /// All legal documents (can be filtered by type, language, active status)
  final List<LegalDocumentModel> documents;

  /// Current legal documents for a specific language
  final CurrentLegalDocumentsResponse? currentDocuments;

  /// Language code for which currentDocuments is loaded
  final String? currentLanguageCode;

  /// List of document IDs that the user has accepted
  final List<int> acceptedConsentIds;

  const LegalDocumentState({
    this.documents = const [],
    this.currentDocuments,
    this.currentLanguageCode,
    this.acceptedConsentIds = const [],
  });

  /// Create a copy with updated fields
  LegalDocumentState copyWith({
    List<LegalDocumentModel>? documents,
    CurrentLegalDocumentsResponse? currentDocuments,
    String? currentLanguageCode,
    List<int>? acceptedConsentIds,
    bool clearDocuments = false,
    bool clearCurrentDocuments = false,
    bool clearAcceptedConsents = false,
  }) {
    return LegalDocumentState(
      documents: clearDocuments ? const [] : (documents ?? this.documents),
      currentDocuments: clearCurrentDocuments
          ? null
          : (currentDocuments ?? this.currentDocuments),
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
      acceptedConsentIds: clearAcceptedConsents
          ? const []
          : (acceptedConsentIds ?? this.acceptedConsentIds),
    );
  }

  /// Get terms of service from current documents
  LegalDocumentModel? get termsOfService => currentDocuments?.termsOfService;

  /// Get privacy policy from current documents
  LegalDocumentModel? get privacyPolicy => currentDocuments?.privacyPolicy;

  /// Get cookie policy from current documents
  LegalDocumentModel? get cookiePolicy => currentDocuments?.cookiePolicy;

  /// Get GDPR consent from current documents
  LegalDocumentModel? get gdprConsent => currentDocuments?.gdprConsent;

  /// Check if a document ID is accepted
  bool isAccepted(int documentId) {
    return acceptedConsentIds.contains(documentId);
  }

  /// Get a document by ID from the documents list
  LegalDocumentModel? getDocumentById(int documentId) {
    try {
      return documents.firstWhere((doc) => doc.id == documentId);
    } catch (e) {
      return null;
    }
  }
}
