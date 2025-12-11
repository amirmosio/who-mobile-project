import 'package:json_annotation/json_annotation.dart';

part 'theory_exam_booking.g.dart';

@JsonSerializable()
class TheoryExamBooking {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'exam_date')
  final String? examDate;

  @JsonKey(name: 'motorisation_name')
  final String? motorisationName;

  @JsonKey(name: 'motorisation_city')
  final String? motorisationCity;

  @JsonKey(name: 'motorisation_address')
  final String? motorisationAddress;

  @JsonKey(name: 'motorisation_province')
  final String? motorisationProvince;

  @JsonKey(name: 'motorisation_zip_code')
  final String? motorisationZipCode;

  @JsonKey(name: 'is_confirmed')
  final bool? isConfirmed;

  @JsonKey(name: 'to_reschedule')
  final bool? toReschedule;

  final bool? result;

  const TheoryExamBooking({
    this.id,
    this.examDate,
    this.motorisationName,
    this.motorisationCity,
    this.motorisationAddress,
    this.motorisationProvince,
    this.motorisationZipCode,
    this.isConfirmed,
    this.toReschedule,
    this.result,
  });

  factory TheoryExamBooking.fromJson(Map<String, dynamic> json) =>
      _$TheoryExamBookingFromJson(json);

  Map<String, dynamic> toJson() => _$TheoryExamBookingToJson(this);

  TheoryExamBooking copyWith({
    String? examDate,
    String? motorisationName,
    String? motorisationCity,
    String? motorisationAddress,
    String? motorisationProvince,
    String? motorisationZipCode,
    bool? isConfirmed,
    bool? toReschedule,
    bool? result,
  }) {
    return TheoryExamBooking(
      id: id,
      examDate: examDate ?? this.examDate,
      motorisationName: motorisationName ?? this.motorisationName,
      motorisationCity: motorisationCity ?? this.motorisationCity,
      motorisationAddress: motorisationAddress ?? this.motorisationAddress,
      motorisationProvince: motorisationProvince ?? this.motorisationProvince,
      motorisationZipCode: motorisationZipCode ?? this.motorisationZipCode,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      toReschedule: toReschedule ?? this.toReschedule,
      result: result ?? this.result,
    );
  }
}
