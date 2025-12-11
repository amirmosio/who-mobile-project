import 'package:who_mobile_project/general/models/base_dropdown_item.dart'
    show BaseDropDownItemModel;

List<Hours> allWorkingHours = [
  for (int i = 0; i < 24; i++)
    Hours(
      name: "${i.toString().padLeft(2, '0')}:00",
      id: "${i.toString().padLeft(2, '0')}:00",
    ),
];

class Hours extends BaseDropDownItemModel {
  Hours({required super.name, required super.id});

  @override
  String get displayName => name;
}
