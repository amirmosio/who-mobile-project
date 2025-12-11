import 'package:json_annotation/json_annotation.dart';

part 'medical_examination.g.dart';

@JsonSerializable()
class MedicalExamination {
  final int? id;
  final String? datetime;
  final String? preferences;
  final String? city;
  final String? address;
  final String? province;
  final String? zipCode;
  @JsonKey(name: 'created_datetime')
  final String? createdDatetime;
  @JsonKey(name: 'is_confirmed')
  final bool? isConfirmed;
  @JsonKey(name: 'to_reschedule')
  final bool? toReschedule;
  @JsonKey(name: 'can_be_refunded')
  final bool? canBeRefunded;
  @JsonKey(name: 'address_changed_reason')
  final String? addressChangedReason;
  final String? notes;

  MedicalExamination({
    this.id,
    this.datetime,
    this.preferences,
    this.city,
    this.address,
    this.province,
    this.zipCode,
    this.createdDatetime,
    this.isConfirmed,
    this.toReschedule,
    this.canBeRefunded,
    this.addressChangedReason,
    this.notes,
  });

  factory MedicalExamination.fromJson(Map<String, dynamic> json) =>
      _$MedicalExaminationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalExaminationToJson(this);
}
