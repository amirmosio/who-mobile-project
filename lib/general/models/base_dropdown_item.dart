abstract class BaseDropDownItemModel {
  final String name;
  final String id;

  BaseDropDownItemModel({required this.name, required this.id});

  String get displayName => name;

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BaseDropDownItemModel) return false;
    return id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
