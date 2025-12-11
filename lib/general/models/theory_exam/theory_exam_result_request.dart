import 'package:json_annotation/json_annotation.dart';

part 'theory_exam_result_request.g.dart';

@JsonSerializable()
class TheoryExamResultRequest {
  final bool result;

  const TheoryExamResultRequest({required this.result});

  factory TheoryExamResultRequest.fromJson(Map<String, dynamic> json) =>
      _$TheoryExamResultRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TheoryExamResultRequestToJson(this);
}
