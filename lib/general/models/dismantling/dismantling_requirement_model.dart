class DismantlingRequirementModel {
  final String id;
  final String title;
  final List<String> content;

  DismantlingRequirementModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory DismantlingRequirementModel.fromJson(Map<String, dynamic> json) {
    return DismantlingRequirementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: (json['content'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
