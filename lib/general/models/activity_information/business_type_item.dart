import 'package:who_mobile_project/general/models/base_dropdown_item.dart'
    show BaseDropDownItemModel;

class BusinessType extends BaseDropDownItemModel {
  BusinessType({required super.id, required super.name});

  factory BusinessType.fromJson(Map<String, dynamic> json) {
    return BusinessType(
      id: json['value'] ?? '',
      name: json['display_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'value': id, 'display_name': name};

  factory BusinessType.empty() {
    return BusinessType(id: '', name: '');
  }
}
