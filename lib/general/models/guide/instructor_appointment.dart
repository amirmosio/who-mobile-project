class InstructorAppointment {
  final int id;
  final String appointmentCode;
  final String appointmentDate;
  final String startTime;
  final String endTime;
  final int durationMinutes;
  final String title;
  final String? meetingPoint;
  final InstructorDetails? instructor;
  final StatusInfo? statusInfo;
  final bool isUpcoming;
  final bool canCancel;
  final CountdownInfo? countdown;

  InstructorAppointment({
    required this.id,
    required this.appointmentCode,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.title,
    this.meetingPoint,
    this.instructor,
    this.statusInfo,
    required this.isUpcoming,
    required this.canCancel,
    this.countdown,
  });

  factory InstructorAppointment.fromJson(Map<String, dynamic> json) {
    return InstructorAppointment(
      id: json['id'] as int,
      appointmentCode: json['appointment_code'] as String,
      appointmentDate: json['appointment_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      durationMinutes: json['duration_minutes'] as int,
      title: json['title'] as String,
      meetingPoint: json['meeting_point'] as String?,
      instructor: json['instructor'] != null
          ? InstructorDetails.fromJson(
              json['instructor'] as Map<String, dynamic>,
            )
          : null,
      statusInfo: json['status_info'] != null
          ? StatusInfo.fromJson(json['status_info'] as Map<String, dynamic>)
          : null,
      isUpcoming: json['is_upcoming'] as bool? ?? false,
      canCancel: json['can_cancel'] as bool? ?? false,
      countdown: json['countdown'] != null
          ? CountdownInfo.fromJson(json['countdown'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_code': appointmentCode,
      'appointment_date': appointmentDate,
      'start_time': startTime,
      'end_time': endTime,
      'duration_minutes': durationMinutes,
      'title': title,
      if (meetingPoint != null) 'meeting_point': meetingPoint,
      if (instructor != null) 'instructor': instructor!.toJson(),
      if (statusInfo != null) 'status_info': statusInfo!.toJson(),
      'is_upcoming': isUpcoming,
      'can_cancel': canCancel,
      if (countdown != null) 'countdown': countdown!.toJson(),
    };
  }

  /// Parse date and time to DateTime
  DateTime get dateTime {
    // Combine appointment_date and start_time
    return DateTime.parse('$appointmentDate $startTime');
  }

  /// Check if reminder should be shown (24 hours before)
  bool get shouldShowDayReminder {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    return difference.inHours <= 24 && difference.inHours > 1;
  }

  /// Check if urgent reminder should be shown (1 hour before)
  bool get shouldShowHourReminder {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    return difference.inHours <= 1 && difference.inMinutes > 0;
  }
}

class InstructorDetails {
  final int id;
  final String name;
  final String? phone;
  final String? image;

  InstructorDetails({
    required this.id,
    required this.name,
    this.phone,
    this.image,
  });

  factory InstructorDetails.fromJson(Map<String, dynamic> json) {
    return InstructorDetails(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (phone != null) 'phone': phone,
      if (image != null) 'image': image,
    };
  }

  /// Get first name from full name
  String get firstName {
    return name.split(' ').first;
  }

  /// Get full name
  String get fullName => name;
}

class StatusInfo {
  final int value;
  final String label;
  final String color;

  StatusInfo({required this.value, required this.label, required this.color});

  factory StatusInfo.fromJson(Map<String, dynamic> json) {
    return StatusInfo(
      value: json['value'] as int,
      label: json['label'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'label': label, 'color': color};
  }
}

class CountdownInfo {
  final int days;
  final int hours;
  final String text;

  CountdownInfo({required this.days, required this.hours, required this.text});

  factory CountdownInfo.fromJson(Map<String, dynamic> json) {
    return CountdownInfo(
      days: json['days'] as int,
      hours: json['hours'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'days': days, 'hours': hours, 'text': text};
  }
}
