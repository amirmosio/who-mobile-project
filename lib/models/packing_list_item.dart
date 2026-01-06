/// Model representing a packing list item
class PackingListItem {
  final String id;
  final String name;
  final int quantity;
  final String dimensions;
  final String? weight;
  final String? imageAsset;
  final String? description;
  final int level; // 1 or 2 (main pack or sub-item)
  final String? parentId;

  const PackingListItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.dimensions,
    this.weight,
    this.imageAsset,
    this.description,
    required this.level,
    this.parentId,
  });

  PackingListItem copyWith({
    String? id,
    String? name,
    int? quantity,
    String? dimensions,
    String? weight,
    String? imageAsset,
    String? description,
    int? level,
    String? parentId,
  }) {
    return PackingListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      imageAsset: imageAsset ?? this.imageAsset,
      description: description ?? this.description,
      level: level ?? this.level,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'dimensions': dimensions,
      'weight': weight,
      'imageAsset': imageAsset,
      'description': description,
      'level': level,
      'parentId': parentId,
    };
  }

  factory PackingListItem.fromJson(Map<String, dynamic> json) {
    return PackingListItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      dimensions: json['dimensions'] as String,
      weight: json['weight'] as String?,
      imageAsset: json['imageAsset'] as String?,
      description: json['description'] as String?,
      level: json['level'] as int,
      parentId: json['parentId'] as String?,
    );
  }
}
