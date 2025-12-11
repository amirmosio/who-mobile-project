import 'package:collection/collection.dart';

class AvailablePagesResponse {
  final List<AvailablePageItem> items;

  bool hasPagePermission(String pageId) {
    return (items.singleWhereOrNull((element) {
              return element.identifier == pageId;
            }) ??
            items
                .expand<AvailableSubPageItem?>(
                  (element) => element.subItems ?? [],
                )
                .singleWhereOrNull((element) {
                  return (element?.identifier ?? "") == pageId;
                })) !=
        null;
  }

  AvailablePagesResponse({required this.items});

  factory AvailablePagesResponse.fromJson(Map<String, dynamic> json) {
    return AvailablePagesResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => AvailablePageItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((item) => item.toJson()).toList()};
  }
}

class AvailablePageItem {
  final String identifier;
  final String name;
  final List<AvailableSubPageItem>? subItems;

  AvailablePageItem({
    required this.identifier,
    required this.name,
    required this.subItems,
  });

  factory AvailablePageItem.fromJson(Map<String, dynamic> json) {
    return AvailablePageItem(
      identifier: json['identifier'] ?? '',
      name: json['name'] ?? '',
      subItems: (json['sub_items'] as List<dynamic>?)
          ?.map((item) => AvailableSubPageItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'name': name,
      'sub_items': subItems?.map((item) => item.toJson()).toList(),
    };
  }
}

class AvailableSubPageItem {
  final String identifier;
  final String name;

  AvailableSubPageItem({required this.identifier, required this.name});

  factory AvailableSubPageItem.fromJson(Map<String, dynamic> json) {
    return AvailableSubPageItem(
      identifier: json['identifier'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'identifier': identifier, 'name': name};
  }
}
