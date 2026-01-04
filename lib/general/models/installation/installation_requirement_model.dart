class InstallationRequirementModel {
  final String id;
  final String title;
  final List<String> content;

  InstallationRequirementModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory InstallationRequirementModel.fromJson(Map<String, dynamic> json) {
    return InstallationRequirementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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
