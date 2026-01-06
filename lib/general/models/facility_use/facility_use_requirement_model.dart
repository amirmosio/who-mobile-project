import 'facility_use_image_model.dart';

class FacilityUseRequirementModel {
  final String id;
  final String title;
  final List<String> content;
  final List<FacilityUseImageModel>? images;

  FacilityUseRequirementModel({
    required this.id,
    required this.title,
    required this.content,
    this.images,
  });

  factory FacilityUseRequirementModel.fromJson(Map<String, dynamic> json) {
    return FacilityUseRequirementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => FacilityUseImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      if (images != null) 'images': images!.map((e) => e.toJson()).toList(),
    };
  }
}
