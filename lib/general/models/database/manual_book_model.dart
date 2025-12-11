import 'dart:convert';

/// Manual Book model from API
/// Matches backend ManualBook model (guidaevai/models.py:ManualBook)
/// Used for QR code-based training exercises - groups manuals by topic/argument
class ManualBookModel {
  final int id;
  final int? argument; // Topic/Argument ID
  final List<int>? manuals; // Array of manual IDs
  final String createdDatetime;
  final String modifiedDatetime;

  ManualBookModel({
    required this.id,
    this.argument,
    this.manuals,
    required this.createdDatetime,
    required this.modifiedDatetime,
  });

  factory ManualBookModel.fromJson(Map<String, dynamic> json) {
    return ManualBookModel(
      id: json['id'] as int,
      argument: json['argument'] as int?,
      manuals: json['manuals'] != null
          ? List<int>.from(json['manuals'] as List)
          : null,
      createdDatetime: json['created_datetime'] as String,
      modifiedDatetime: json['modified_datetime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (argument != null) 'argument': argument,
      if (manuals != null) 'manuals': manuals,
      'created_datetime': createdDatetime,
      'modified_datetime': modifiedDatetime,
    };
  }

  /// Serialize manuals array to JSON string for database storage
  String? get manualsJson {
    if (manuals == null) return null;
    return jsonEncode(manuals);
  }

  /// Deserialize manuals from JSON string
  static List<int>? manualsFromJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      return List<int>.from(jsonDecode(jsonString) as List);
    } catch (e) {
      return null;
    }
  }
}
