/// Document types enum matching the backend API
/// Based on Neith app implementation
enum DocumentType {
  /// Type 0: Identity Card (Carta d'identità)
  /// Requires front and back images
  /// Has same_residence_as_id_card field
  identityCard(0, 'identityCard', 'document_ci', true, true, false, false),

  /// Type 1: Health Insurance Card (Tessera sanitaria)
  /// Requires front and back images
  healthInsuranceCard(
    1,
    'healthCard',
    'frontAndBackRequired',
    true,
    false,
    false,
    false,
  ),

  /// Type 2: Certificate of Residence (Certificato di residenza)
  /// Single image document
  /// Has same_residence_as_id_card field
  certificateOfResidence(
    2,
    'certificateOfResidence',
    'onlyIfDifferentFromIdCard',
    false,
    false,
    true,
    false,
  ),

  /// Type 3: Residence Permit (Permesso di soggiorno)
  /// Requires front and back images
  /// Has is_italian_citizen field
  residencePermit(
    3,
    'residencePermit',
    'onlyForNonEuCitizens',
    true,
    false,
    false,
    true,
  ),

  /// Type 4: Medical History Certificate (Certificato anamnestico)
  /// Requires front and optional back images
  /// Has has_pathology field (always false)
  medicalHistoryCertificate(
    4,
    'medicalCertificate',
    'issuedByAuthorizedDoctor',
    true,
    false,
    false,
    false,
  ),

  /// Type 5: ID Photo (Foto tessera)
  /// Single image document
  idPhoto(5, 'passportPhoto', 'jpgPngFormat', false, false, false, false),

  /// Type 6: Digital Signature (Firma)
  /// Single image document
  digitalSignature(
    6,
    'digitalSignature',
    'signatureOnWhiteBackground',
    false,
    false,
    false,
    false,
  ),

  /// Type 7: Medical Examination Certificate (Certificato visita medica)
  /// Requires front and optional back images
  /// Has has_pathology field (always false)
  medicalExaminationCertificate(
    7,
    'medicalExaminationCertificate',
    'issuedByAuthorizedDoctor',
    true,
    false,
    false,
    false,
  );

  final int id;
  final String titleKey;
  final String subtitleKey;
  final bool needsBothSides;
  final bool hasSameResidenceField;
  final bool hasItalianCitizenField;
  final bool hasPathologyField;

  const DocumentType(
    this.id,
    this.titleKey,
    this.subtitleKey,
    this.needsBothSides,
    this.hasSameResidenceField,
    this.hasItalianCitizenField,
    this.hasPathologyField,
  );

  /// Get document type by ID
  static DocumentType? fromId(int id) {
    try {
      return DocumentType.values.firstWhere((type) => type.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get document type by title key
  static DocumentType? fromTitleKey(String titleKey) {
    try {
      return DocumentType.values.firstWhere(
        (type) => type.titleKey == titleKey,
      );
    } catch (e) {
      return null;
    }
  }
}
