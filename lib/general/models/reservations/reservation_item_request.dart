class ReservationItemRequest {
  final String clientEmail;
  final String clientFullName;
  final String clientPhoneNumber;
  final String description;
  final String details;
  final String summary;
  final DateTime startingDate;
  final DateTime endingDate;

  ReservationItemRequest({
    required this.clientEmail,
    required this.clientFullName,
    required this.clientPhoneNumber,
    required this.description,
    required this.details,
    required this.summary,
    required this.startingDate,
    required this.endingDate,
  });

  factory ReservationItemRequest.fromJson(Map<String, dynamic> json) {
    return ReservationItemRequest(
      clientEmail: json['client_email'] ?? '',
      clientFullName: json['client_full_name'] ?? '',
      clientPhoneNumber: json['client_phone_number'] ?? '',
      description: json['description'] ?? '',
      details: json['details'] ?? '',
      summary: json['summary'] ?? '',
      startingDate: DateTime.parse(json['starting_date']),
      endingDate: DateTime.parse(json['ending_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_email': clientEmail,
      'client_full_name': clientFullName,
      'client_phone_number': clientPhoneNumber,
      'description': description,
      'details': details,
      'summary': summary,
      'starting_date': startingDate.toIso8601String(),
      'ending_date': endingDate.toIso8601String(),
    };
  }
}
