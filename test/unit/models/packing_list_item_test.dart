import 'package:flutter_test/flutter_test.dart';
import 'package:who_mobile_project/models/packing_list_item.dart';

void main() {
  group('PackingListItem', () {
    test('should create a PackingListItem with required fields', () {
      // Arrange & Act
      final item = PackingListItem(
        id: '1',
        name: 'Test Item',
        quantity: 5,
        dimensions: '10x20x30',
        level: 1,
      );

      // Assert
      expect(item.id, '1');
      expect(item.name, 'Test Item');
      expect(item.quantity, 5);
      expect(item.dimensions, '10x20x30');
      expect(item.level, 1);
      expect(item.weight, isNull);
      expect(item.imageAsset, isNull);
      expect(item.description, isNull);
      expect(item.parentId, isNull);
    });

    test('should create a PackingListItem with all fields', () {
      // Arrange & Act
      final item = PackingListItem(
        id: '2',
        name: 'Complete Item',
        quantity: 10,
        dimensions: '15x25x35',
        weight: '5kg',
        imageAsset: 'assets/images/item.png',
        description: 'A complete test item',
        level: 2,
        parentId: '1',
      );

      // Assert
      expect(item.id, '2');
      expect(item.name, 'Complete Item');
      expect(item.quantity, 10);
      expect(item.dimensions, '15x25x35');
      expect(item.weight, '5kg');
      expect(item.imageAsset, 'assets/images/item.png');
      expect(item.description, 'A complete test item');
      expect(item.level, 2);
      expect(item.parentId, '1');
    });

    test('copyWith should create a new instance with updated fields', () {
      // Arrange
      final original = PackingListItem(
        id: '1',
        name: 'Original',
        quantity: 5,
        dimensions: '10x10x10',
        level: 1,
      );

      // Act
      final updated = original.copyWith(
        name: 'Updated',
        quantity: 10,
      );

      // Assert
      expect(updated.id, '1');
      expect(updated.name, 'Updated');
      expect(updated.quantity, 10);
      expect(updated.dimensions, '10x10x10');
      expect(updated.level, 1);
      expect(original.name, 'Original'); // Original unchanged
      expect(original.quantity, 5); // Original unchanged
    });

    test('copyWith should preserve original fields when not specified', () {
      // Arrange
      final original = PackingListItem(
        id: '1',
        name: 'Original',
        quantity: 5,
        dimensions: '10x10x10',
        weight: '2kg',
        level: 1,
      );

      // Act
      final updated = original.copyWith(name: 'Updated');

      // Assert
      expect(updated.id, original.id);
      expect(updated.name, 'Updated');
      expect(updated.quantity, original.quantity);
      expect(updated.dimensions, original.dimensions);
      expect(updated.weight, original.weight);
      expect(updated.level, original.level);
    });

    test('toJson should convert PackingListItem to Map', () {
      // Arrange
      final item = PackingListItem(
        id: '1',
        name: 'Test Item',
        quantity: 5,
        dimensions: '10x20x30',
        weight: '3kg',
        imageAsset: 'assets/test.png',
        description: 'Test description',
        level: 1,
        parentId: '0',
      );

      // Act
      final json = item.toJson();

      // Assert
      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], '1');
      expect(json['name'], 'Test Item');
      expect(json['quantity'], 5);
      expect(json['dimensions'], '10x20x30');
      expect(json['weight'], '3kg');
      expect(json['imageAsset'], 'assets/test.png');
      expect(json['description'], 'Test description');
      expect(json['level'], 1);
      expect(json['parentId'], '0');
    });

    test('toJson should include null values', () {
      // Arrange
      final item = PackingListItem(
        id: '1',
        name: 'Test Item',
        quantity: 5,
        dimensions: '10x20x30',
        level: 1,
      );

      // Act
      final json = item.toJson();

      // Assert
      expect(json['weight'], isNull);
      expect(json['imageAsset'], isNull);
      expect(json['description'], isNull);
      expect(json['parentId'], isNull);
    });

    test('fromJson should create PackingListItem from Map', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'Test Item',
        'quantity': 5,
        'dimensions': '10x20x30',
        'weight': '3kg',
        'imageAsset': 'assets/test.png',
        'description': 'Test description',
        'level': 1,
        'parentId': '0',
      };

      // Act
      final item = PackingListItem.fromJson(json);

      // Assert
      expect(item.id, '1');
      expect(item.name, 'Test Item');
      expect(item.quantity, 5);
      expect(item.dimensions, '10x20x30');
      expect(item.weight, '3kg');
      expect(item.imageAsset, 'assets/test.png');
      expect(item.description, 'Test description');
      expect(item.level, 1);
      expect(item.parentId, '0');
    });

    test('fromJson should handle null optional fields', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'Test Item',
        'quantity': 5,
        'dimensions': '10x20x30',
        'weight': null,
        'imageAsset': null,
        'description': null,
        'level': 1,
        'parentId': null,
      };

      // Act
      final item = PackingListItem.fromJson(json);

      // Assert
      expect(item.weight, isNull);
      expect(item.imageAsset, isNull);
      expect(item.description, isNull);
      expect(item.parentId, isNull);
    });

    test('toJson and fromJson should be reversible', () {
      // Arrange
      final original = PackingListItem(
        id: '1',
        name: 'Test Item',
        quantity: 5,
        dimensions: '10x20x30',
        weight: '3kg',
        imageAsset: 'assets/test.png',
        description: 'Test description',
        level: 2,
        parentId: '0',
      );

      // Act
      final json = original.toJson();
      final restored = PackingListItem.fromJson(json);

      // Assert
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.quantity, original.quantity);
      expect(restored.dimensions, original.dimensions);
      expect(restored.weight, original.weight);
      expect(restored.imageAsset, original.imageAsset);
      expect(restored.description, original.description);
      expect(restored.level, original.level);
      expect(restored.parentId, original.parentId);
    });

    test('should handle level 1 (main pack) items', () {
      // Arrange & Act
      final mainPack = PackingListItem(
        id: '1',
        name: 'Main Pack',
        quantity: 1,
        dimensions: '100x100x100',
        level: 1,
      );

      // Assert
      expect(mainPack.level, 1);
      expect(mainPack.parentId, isNull);
    });

    test('should handle level 2 (sub-item) items', () {
      // Arrange & Act
      final subItem = PackingListItem(
        id: '2',
        name: 'Sub Item',
        quantity: 3,
        dimensions: '20x20x20',
        level: 2,
        parentId: '1',
      );

      // Assert
      expect(subItem.level, 2);
      expect(subItem.parentId, '1');
    });

    test('should handle edge case with zero quantity', () {
      // Arrange & Act
      final item = PackingListItem(
        id: '1',
        name: 'Zero Quantity Item',
        quantity: 0,
        dimensions: '10x10x10',
        level: 1,
      );

      // Assert
      expect(item.quantity, 0);
    });

    test('should handle edge case with large quantity', () {
      // Arrange & Act
      final item = PackingListItem(
        id: '1',
        name: 'Large Quantity Item',
        quantity: 999999,
        dimensions: '10x10x10',
        level: 1,
      );

      // Assert
      expect(item.quantity, 999999);
    });

    test('should handle empty strings', () {
      // Arrange & Act
      final item = PackingListItem(
        id: '',
        name: '',
        quantity: 1,
        dimensions: '',
        level: 1,
      );

      // Assert
      expect(item.id, '');
      expect(item.name, '');
      expect(item.dimensions, '');
    });
  });
}
