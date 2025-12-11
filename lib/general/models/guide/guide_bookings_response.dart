import 'guide_booking.dart';

class GuideBookingsResponse {
  final List<GuideBooking> currentBookings;
  final List<GuideBooking> pastBookings;
  final int totalCompletedGuides;
  final double progressPercentage;

  GuideBookingsResponse({
    required this.currentBookings,
    required this.pastBookings,
    required this.totalCompletedGuides,
    required this.progressPercentage,
  });

  factory GuideBookingsResponse.fromJson(Map<String, dynamic> json) {
    return GuideBookingsResponse(
      currentBookings: (json['current_bookings'] as List<dynamic>)
          .map((item) => GuideBooking.fromJson(item as Map<String, dynamic>))
          .toList(),
      pastBookings: (json['past_bookings'] as List<dynamic>)
          .map((item) => GuideBooking.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCompletedGuides: json['total_completed_guides'] as int,
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_bookings': currentBookings
          .map((booking) => booking.toJson())
          .toList(),
      'past_bookings': pastBookings.map((booking) => booking.toJson()).toList(),
      'total_completed_guides': totalCompletedGuides,
      'progress_percentage': progressPercentage,
    };
  }
}
