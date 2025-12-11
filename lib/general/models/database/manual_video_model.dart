/// Manual Video model from API
/// Represents the video object in ManualModel
class ManualVideoModel {
  final int id;

  ManualVideoModel({required this.id});

  factory ManualVideoModel.fromJson(Map<String, dynamic> json) {
    return ManualVideoModel(id: json['id'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManualVideoModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ManualVideoModel(id: $id)';
}
