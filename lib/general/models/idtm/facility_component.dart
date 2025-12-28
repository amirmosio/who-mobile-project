/// Represents a physical component of the facility
class FacilityComponent {
  /// Unique identifier for the component
  final String id;

  /// Component name
  final String name;

  /// Component description
  final String description;

  /// Category (e.g., "Main Tent", "Vestibule", "Flooring", "Panel")
  final String category;

  /// Quantity required
  final int quantity;

  /// Unit (e.g., "pieces", "meters", "sets")
  final String unit;

  /// Image asset path
  final String? imageUrl;

  /// Dimensions (e.g., "3.00m x 4.70m")
  final String? dimensions;

  /// Weight in kg
  final double? weight;

  /// Material/fabric type
  final String? material;

  /// Color
  final String? color;

  /// Installation order/priority
  final int? installationOrder;

  const FacilityComponent({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.quantity,
    required this.unit,
    this.imageUrl,
    this.dimensions,
    this.weight,
    this.material,
    this.color,
    this.installationOrder,
  });

  factory FacilityComponent.fromJson(Map<String, dynamic> json) {
    return FacilityComponent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
      imageUrl: json['imageUrl'] as String?,
      dimensions: json['dimensions'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      material: json['material'] as String?,
      color: json['color'] as String?,
      installationOrder: json['installationOrder'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'imageUrl': imageUrl,
      'dimensions': dimensions,
      'weight': weight,
      'material': material,
      'color': color,
      'installationOrder': installationOrder,
    };
  }

  FacilityComponent copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? quantity,
    String? unit,
    String? imageUrl,
    String? dimensions,
    double? weight,
    String? material,
    String? color,
    int? installationOrder,
  }) {
    return FacilityComponent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      material: material ?? this.material,
      color: color ?? this.color,
      installationOrder: installationOrder ?? this.installationOrder,
    );
  }
}
