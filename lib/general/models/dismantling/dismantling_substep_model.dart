class DismantlingSubstepModel {
  final String id;
  final int stepNumber;
  final String title;
  final String purpose;
  final List<String> actions;
  final String? criticalWarning;
  final String? criticalNote;

  DismantlingSubstepModel({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.purpose,
    required this.actions,
    this.criticalWarning,
    this.criticalNote,
  });

  factory DismantlingSubstepModel.fromJson(Map<String, dynamic> json) {
    return DismantlingSubstepModel(
      id: json['id'] as String,
      stepNumber: json['stepNumber'] as int,
      title: json['title'] as String,
      purpose: json['purpose'] as String,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      criticalWarning: json['criticalWarning'] as String?,
      criticalNote: json['criticalNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stepNumber': stepNumber,
      'title': title,
      'purpose': purpose,
      'actions': actions,
      if (criticalWarning != null) 'criticalWarning': criticalWarning,
      if (criticalNote != null) 'criticalNote': criticalNote,
    };
  }
}
