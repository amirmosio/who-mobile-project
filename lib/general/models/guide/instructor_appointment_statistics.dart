import 'package:json_annotation/json_annotation.dart';

part 'instructor_appointment_statistics.g.dart';

/// Statistics for instructor appointments
@JsonSerializable()
class InstructorAppointmentStatistics {
  /// Total statistics
  final AppointmentTotals totals;

  /// Completion and cancellation rates
  final AppointmentRates rates;

  /// Favorite instructor (if any)
  final FavoriteInstructor? favorites;

  InstructorAppointmentStatistics({
    required this.totals,
    required this.rates,
    this.favorites,
  });

  factory InstructorAppointmentStatistics.fromJson(Map<String, dynamic> json) =>
      _$InstructorAppointmentStatisticsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InstructorAppointmentStatisticsToJson(this);
}

/// Appointment totals breakdown
@JsonSerializable()
class AppointmentTotals {
  /// Total number of appointments
  @JsonKey(name: 'total_appointments')
  final int totalAppointments;

  /// Number of completed appointments
  final int completed;

  /// Number of upcoming appointments
  final int upcoming;

  /// Number of cancelled appointments
  final int cancelled;

  /// Total hours of appointments
  @JsonKey(name: 'total_hours')
  final int totalHours;

  AppointmentTotals({
    required this.totalAppointments,
    required this.completed,
    required this.upcoming,
    required this.cancelled,
    required this.totalHours,
  });

  factory AppointmentTotals.fromJson(Map<String, dynamic> json) =>
      _$AppointmentTotalsFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentTotalsToJson(this);
}

/// Appointment rates
@JsonSerializable()
class AppointmentRates {
  /// Completion rate (0-100)
  @JsonKey(name: 'completion_rate')
  final int completionRate;

  /// Cancellation rate (0-100)
  @JsonKey(name: 'cancellation_rate')
  final int cancellationRate;

  AppointmentRates({
    required this.completionRate,
    required this.cancellationRate,
  });

  factory AppointmentRates.fromJson(Map<String, dynamic> json) =>
      _$AppointmentRatesFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentRatesToJson(this);
}

/// Favorite instructor information
@JsonSerializable()
class FavoriteInstructor {
  /// Instructor ID (nullable as API returns null when no favorite)
  final int? instructor;

  FavoriteInstructor({this.instructor});

  factory FavoriteInstructor.fromJson(Map<String, dynamic> json) =>
      _$FavoriteInstructorFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteInstructorToJson(this);
}
