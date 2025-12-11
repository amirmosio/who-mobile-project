import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:who_mobile_project/general/constants/reservation_status_types.dart';
import 'package:who_mobile_project/general/utils/date_time.dart';

class ReservationItem {
  final String id;
  final String organizationId;
  final String clientEmail;
  final String clientFullName;
  final String clientPhoneNumber;
  final String description;
  final String details;
  final String location;
  final String summary;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startingDateUtc;
  final DateTime endingDateUtc;

  Color get color {
    return statusType.color;
  }

  ReservationStatusType get statusType {
    return ReservationStatusType.values.firstWhereOrNull(
          (element) => element.id == status,
        ) ??
        ReservationStatusType.pending;
  }

  String get startEndDateString {
    String startDateString = DateTimeUtils.convertDateTimeToString(
      startingDateUtc,
    );
    String endDateString = DateTimeUtils.convertDateTimeToString(endingDateUtc);
    return "$startDateString - $endDateString";
  }

  String get startEndTimeString {
    final startHour = startingDateUtc.toLocal().hour.toString().padLeft(2, '0');
    final startMinute = startingDateUtc.toLocal().minute.toString().padLeft(
      2,
      '0',
    );
    final endHour = endingDateUtc.toLocal().hour.toString().padLeft(2, '0');
    final endMinute = endingDateUtc.toLocal().minute.toString().padLeft(2, '0');

    return "$startHour:$startMinute - $endHour:$endMinute";
  }

  ReservationItem({
    required this.id,
    required this.organizationId,
    required this.clientEmail,
    required this.clientFullName,
    required this.clientPhoneNumber,
    required this.description,
    required this.details,
    required this.location,
    required this.summary,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.startingDateUtc,
    required this.endingDateUtc,
  });

  factory ReservationItem.fromJson(Map<String, dynamic> json) {
    return ReservationItem(
      id: json['id'] ?? '',
      organizationId: json['organization_id'] ?? '',
      clientEmail: json['client_email'] ?? '',
      clientFullName: json['client_full_name'] ?? '',
      clientPhoneNumber: json['client_phone_number'] ?? '',
      description: json['description'] ?? '',
      details: json['details'] ?? '',
      location: json['location'] ?? '',
      summary: json['summary'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      startingDateUtc: DateTime.parse(json['starting_date']),
      endingDateUtc: DateTime.parse(json['ending_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'client_email': clientEmail,
      'client_full_name': clientFullName,
      'client_phone_number': clientPhoneNumber,
      'description': description,
      'details': details,
      'location': location,
      'summary': summary,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'starting_date': startingDateUtc.toIso8601String(),
      'ending_date': endingDateUtc.toIso8601String(),
    };
  }
}
