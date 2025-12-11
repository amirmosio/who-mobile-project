import 'package:json_annotation/json_annotation.dart';

part 'book_medical_examination_request.g.dart';

@JsonSerializable()
class BookMedicalExaminationRequest {
  final String province;
  final String city;
  final String? preferences;
  @JsonKey(name: 'address_changed_reason')
  final String? addressChangedReason;

  BookMedicalExaminationRequest({
    required this.province,
    required this.city,
    this.preferences,
    this.addressChangedReason,
  });

  factory BookMedicalExaminationRequest.fromJson(Map<String, dynamic> json) =>
      _$BookMedicalExaminationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookMedicalExaminationRequestToJson(this);
}
