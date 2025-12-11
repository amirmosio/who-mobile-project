/// User document model matching backend UserDocument
class UserDocumentModel {
  final int id;
  final int type;
  final bool isValid;
  final bool isProcessing;
  final String? frontPic;
  final String? backPic;
  final bool? isItalianCitizen;
  final bool? sameResidenceAsIdCard;
  final bool? hasPathology;
  final String? invalidityReason;
  final String? note;
  final DateTime? expireDatetime;

  const UserDocumentModel({
    required this.id,
    required this.type,
    required this.isValid,
    required this.isProcessing,
    this.frontPic,
    this.backPic,
    this.isItalianCitizen,
    this.sameResidenceAsIdCard,
    this.hasPathology,
    this.invalidityReason,
    this.note,
    this.expireDatetime,
  });

  factory UserDocumentModel.fromJson(Map<String, dynamic> json) {
    return UserDocumentModel(
      id: json['id'] as int,
      type: json['type'] as int,
      isValid: json['is_valid'] as bool,
      isProcessing: json['is_processing'] as bool,
      frontPic: json['front_pic'] as String?,
      backPic: json['back_pic'] as String?,
      isItalianCitizen: json['is_italian_citizen'] as bool?,
      sameResidenceAsIdCard: json['same_residence_as_id_card'] as bool?,
      hasPathology: json['has_pathology'] as bool?,
      invalidityReason: json['invalidity_reason'] as String?,
      note: json['note'] as String?,
      expireDatetime: json['expire_datetime'] != null
          ? DateTime.tryParse(json['expire_datetime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'is_valid': isValid,
      'is_processing': isProcessing,
      'front_pic': frontPic,
      'back_pic': backPic,
      'is_italian_citizen': isItalianCitizen,
      'same_residence_as_id_card': sameResidenceAsIdCard,
      'has_pathology': hasPathology,
      'invalidity_reason': invalidityReason,
      'note': note,
      'expire_datetime': expireDatetime?.toIso8601String(),
    };
  }

  /// Check if document has been uploaded (has images or is being processed)
  bool get isUploaded {
    return (frontPic != null && frontPic!.isNotEmpty) ||
        (backPic != null && backPic!.isNotEmpty) ||
        isProcessing ||
        isValid;
  }

  /// Get document type name
  String get typeName {
    switch (type) {
      case 0:
        return "Carta d'identità";
      case 1:
        return 'Tessera sanitaria';
      case 2:
        return 'Certificato di residenza';
      case 3:
        return 'Permesso di soggiorno';
      case 4:
        return 'Certificato anamnestico';
      case 5:
        return 'Foto tessera';
      case 6:
        return 'Firma';
      case 7:
        return 'Certificato visita medica';
      default:
        return 'Altro';
    }
  }
}
