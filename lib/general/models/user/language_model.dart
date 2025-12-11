/// Language model for license types
/// Matches the language structure from the API response
class Language {
  final int id;
  final String name;
  final String code;
  final String? image;

  const Language({
    required this.id,
    required this.name,
    required this.code,
    this.image,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      if (image != null) 'image': image,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => id.hashCode ^ code.hashCode;

  @override
  String toString() => 'Language(id: $id, name: $name, code: $code)';
}
