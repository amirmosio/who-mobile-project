import 'package:json_annotation/json_annotation.dart';

part 'teacher_model.g.dart';

@JsonSerializable()
class TeacherModel {
  final int id;
  final String? firstname;
  final String? surname;
  @JsonKey(name: 'zoom_url')
  final String? zoomUrl;
  final String? image;

  const TeacherModel({
    required this.id,
    this.firstname,
    this.surname,
    this.zoomUrl,
    this.image,
  });

  String? get fullName {
    if (firstname == null && surname == null) return null;
    return "${firstname ?? ''} ${surname ?? ''}".trim();
  }

  // Backward compatibility getter for firstName
  String? get firstName => firstname;

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);

  @override
  String toString() => 'TeacherModel(id: $id, fullName: $fullName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
