import 'instructor_appointment.dart';

class InstructorAppointmentsResponse {
  final List<InstructorAppointment> appointments;
  final int totalCount;
  final AppointmentsSummary? summary;

  InstructorAppointmentsResponse({
    required this.appointments,
    required this.totalCount,
    this.summary,
  });

  factory InstructorAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    return InstructorAppointmentsResponse(
      appointments:
          (json['appointments'] as List<dynamic>?)
              ?.map(
                (item) => InstructorAppointment.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      totalCount: json['total_count'] as int? ?? 0,
      summary: json['summary'] != null
          ? AppointmentsSummary.fromJson(
              json['summary'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointments': appointments.map((a) => a.toJson()).toList(),
      'total_count': totalCount,
      if (summary != null) 'summary': summary!.toJson(),
    };
  }

  /// Get only upcoming appointments
  List<InstructorAppointment> get upcomingAppointments {
    return appointments.where((a) => a.isUpcoming).toList();
  }
}

class UpcomingAppointmentsResponse {
  final int count;
  final List<InstructorAppointment> upcomingAppointments;
  final InstructorAppointment? nextAppointment;

  UpcomingAppointmentsResponse({
    required this.count,
    required this.upcomingAppointments,
    this.nextAppointment,
  });

  factory UpcomingAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointmentsResponse(
      count: json['count'] as int? ?? 0,
      upcomingAppointments:
          (json['appointments'] as List<dynamic>?)
              ?.map(
                (item) => InstructorAppointment.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      nextAppointment: json['next_appointment'] != null
          ? InstructorAppointment.fromJson(
              json['next_appointment'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'appointments': upcomingAppointments.map((a) => a.toJson()).toList(),
      if (nextAppointment != null)
        'next_appointment': nextAppointment!.toJson(),
    };
  }
}

class AppointmentsSummary {
  final int totalUpcoming;
  final int totalCompleted;
  final int totalCancelled;

  AppointmentsSummary({
    required this.totalUpcoming,
    required this.totalCompleted,
    required this.totalCancelled,
  });

  factory AppointmentsSummary.fromJson(Map<String, dynamic> json) {
    return AppointmentsSummary(
      totalUpcoming: json['total_upcoming'] as int? ?? 0,
      totalCompleted: json['total_completed'] as int? ?? 0,
      totalCancelled: json['total_cancelled'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_upcoming': totalUpcoming,
      'total_completed': totalCompleted,
      'total_cancelled': totalCancelled,
    };
  }
}
