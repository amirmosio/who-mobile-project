class GuideBooking {
  final String id;
  final String instructorId;
  final String instructorName;
  final String instructorImageUrl;
  final double rating;
  final int reviewCount;
  final String school;
  final String location;
  final DateTime date;
  final String timeSlot;
  final GuideBookingStatus status;
  final bool canCancel;

  GuideBooking({
    required this.id,
    required this.instructorId,
    required this.instructorName,
    required this.instructorImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.school,
    required this.location,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.canCancel,
  });

  factory GuideBooking.fromJson(Map<String, dynamic> json) {
    return GuideBooking(
      id: json['id'] as String,
      instructorId: json['instructor_id'] as String,
      instructorName: json['instructor_name'] as String,
      instructorImageUrl: json['instructor_image_url'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      school: json['school'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSlot: json['time_slot'] as String,
      status: GuideBookingStatus.fromString(json['status'] as String),
      canCancel: json['can_cancel'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instructor_id': instructorId,
      'instructor_name': instructorName,
      'instructor_image_url': instructorImageUrl,
      'rating': rating,
      'review_count': reviewCount,
      'school': school,
      'location': location,
      'date': date.toIso8601String(),
      'time_slot': timeSlot,
      'status': status.value,
      'can_cancel': canCancel,
    };
  }

  GuideBooking copyWith({
    String? id,
    String? instructorId,
    String? instructorName,
    String? instructorImageUrl,
    double? rating,
    int? reviewCount,
    String? school,
    String? location,
    DateTime? date,
    String? timeSlot,
    GuideBookingStatus? status,
    bool? canCancel,
  }) {
    return GuideBooking(
      id: id ?? this.id,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      instructorImageUrl: instructorImageUrl ?? this.instructorImageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      school: school ?? this.school,
      location: location ?? this.location,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      canCancel: canCancel ?? this.canCancel,
    );
  }
}

enum GuideBookingStatus {
  scheduled,
  completed,
  cancelled;

  String get value {
    switch (this) {
      case GuideBookingStatus.scheduled:
        return 'scheduled';
      case GuideBookingStatus.completed:
        return 'completed';
      case GuideBookingStatus.cancelled:
        return 'cancelled';
    }
  }

  static GuideBookingStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'scheduled':
        return GuideBookingStatus.scheduled;
      case 'completed':
        return GuideBookingStatus.completed;
      case 'cancelled':
        return GuideBookingStatus.cancelled;
      default:
        throw ArgumentError('Invalid GuideBookingStatus: $value');
    }
  }
}
