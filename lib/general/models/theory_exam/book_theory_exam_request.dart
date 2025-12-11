import 'package:json_annotation/json_annotation.dart';

part 'book_theory_exam_request.g.dart';

@JsonSerializable()
class BookTheoryExamRequest {
  final String province;

  @JsonKey(name: 'was_ready_for_exam')
  final bool wasReadyForExam;

  const BookTheoryExamRequest({
    required this.province,
    required this.wasReadyForExam,
  });

  factory BookTheoryExamRequest.fromJson(Map<String, dynamic> json) =>
      _$BookTheoryExamRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookTheoryExamRequestToJson(this);
}
