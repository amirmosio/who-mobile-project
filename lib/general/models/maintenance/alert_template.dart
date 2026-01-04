import 'package:cloud_firestore/cloud_firestore.dart';

/// Priority levels for maintenance alerts
enum AlertPriority {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  const AlertPriority(this.value);
  final String value;

  static AlertPriority fromString(String value) {
    return AlertPriority.values.firstWhere(
      (p) => p.value == value,
      orElse: () => AlertPriority.medium,
    );
  }

  String get displayName {
    switch (this) {
      case AlertPriority.low:
        return 'Low';
      case AlertPriority.medium:
        return 'Medium';
      case AlertPriority.high:
        return 'High';
      case AlertPriority.critical:
        return 'Critical';
    }
  }
}

/// Model representing a maintenance alert template
/// Created by Super Admin, applied to all admins when they enter maintenance phase
class AlertTemplate {
  final String id;
  final String facilityId;
  final String facilityName;
  final String title;
  final String description;
  final int intervalHours;
  final AlertPriority priority;
  final bool isActive;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertTemplate({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.title,
    required this.description,
    required this.intervalHours,
    required this.priority,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlertTemplate.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AlertTemplate(
      id: doc.id,
      facilityId: data['facilityId'] as String? ?? '',
      facilityName: data['facilityName'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      intervalHours: data['intervalHours'] as int? ?? 24,
      priority:
          AlertPriority.fromString(data['priority'] as String? ?? 'medium'),
      isActive: data['isActive'] as bool? ?? true,
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'facilityId': facilityId,
        'facilityName': facilityName,
        'title': title,
        'description': description,
        'intervalHours': intervalHours,
        'priority': priority.value,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toFirestoreUpdate() => {
        'facilityId': facilityId,
        'facilityName': facilityName,
        'title': title,
        'description': description,
        'intervalHours': intervalHours,
        'priority': priority.value,
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  AlertTemplate copyWith({
    String? id,
    String? facilityId,
    String? facilityName,
    String? title,
    String? description,
    int? intervalHours,
    AlertPriority? priority,
    bool? isActive,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlertTemplate(
      id: id ?? this.id,
      facilityId: facilityId ?? this.facilityId,
      facilityName: facilityName ?? this.facilityName,
      title: title ?? this.title,
      description: description ?? this.description,
      intervalHours: intervalHours ?? this.intervalHours,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get formatted interval string for display
  String get intervalDisplay {
    if (intervalHours < 24) return '$intervalHours hours';
    if (intervalHours == 24) return 'Daily';
    if (intervalHours == 168) return 'Weekly';
    final days = intervalHours ~/ 24;
    return '$days days';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlertTemplate &&
        other.id == id &&
        other.facilityId == facilityId &&
        other.title == title &&
        other.intervalHours == intervalHours;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      facilityId.hashCode ^
      title.hashCode ^
      intervalHours.hashCode;
}
