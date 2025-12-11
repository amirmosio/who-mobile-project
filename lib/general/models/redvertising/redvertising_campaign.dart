import 'package:equatable/equatable.dart';

/// Model representing a Redvertising advertising campaign.
/// Matches iOS implementation from QuizPatente-iOS/QuizPatentePlus/Model/New Model/Redvertising.swift
class RedvertisingCampaign extends Equatable {
  final int id;
  final String title;
  final String description;
  final int viewForUser; // Max times user can see this campaign
  final int secondForSkip; // Delay before showing close button
  final String banner16; // Banner for non-notched devices
  final String banner21; // Banner for notched devices
  final String radius;
  final DateTime startDatetime;
  final String url; // Target URL when ad is clicked
  final String latitude;
  final double fillRate;
  final String longitude;
  final bool isActive;
  final List<AdvertisingImageSet> advertisingImagesetSet;

  const RedvertisingCampaign({
    required this.id,
    required this.title,
    required this.description,
    required this.viewForUser,
    required this.secondForSkip,
    required this.banner16,
    required this.banner21,
    required this.radius,
    required this.startDatetime,
    required this.url,
    required this.latitude,
    required this.fillRate,
    required this.longitude,
    required this.isActive,
    required this.advertisingImagesetSet,
  });

  factory RedvertisingCampaign.fromJson(Map<String, dynamic> json) {
    return RedvertisingCampaign(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      viewForUser: json['view_for_user'] as int? ?? 0,
      secondForSkip: json['second_for_skip'] as int? ?? 5,
      banner16: json['banner_16'] as String? ?? '',
      banner21: json['banner_21'] as String? ?? '',
      radius: json['radius'] as String? ?? '',
      startDatetime: DateTime.parse(json['start_datetime'] as String),
      url: json['url'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '',
      fillRate: (json['fill_rate'] as num?)?.toDouble() ?? 0.0,
      longitude: json['longitude'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      advertisingImagesetSet:
          (json['advertisingimageset_set'] as List<dynamic>?)
              ?.map(
                (item) =>
                    AdvertisingImageSet.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'view_for_user': viewForUser,
      'second_for_skip': secondForSkip,
      'banner_16': banner16,
      'banner_21': banner21,
      'radius': radius,
      'start_datetime': startDatetime.toIso8601String(),
      'url': url,
      'latitude': latitude,
      'fill_rate': fillRate,
      'longitude': longitude,
      'is_active': isActive,
      'advertisingimageset_set': advertisingImagesetSet
          .map((set) => set.toJson())
          .toList(),
    };
  }

  /// Check if this is a Zero Pensieri campaign
  /// Matches iOS: getter isZeroPensieri method
  bool get isZeroPensieri {
    return title.toLowerCase().replaceAll(' ', '').contains('zeropensieri');
  }

  /// Get the appropriate banner URL for the current device
  /// Matches iOS: Uses banner21 for notched devices, banner16 for others
  String getBannerForDevice({required bool hasNotch}) {
    return hasNotch ? banner21 : banner16;
  }

  RedvertisingCampaign copyWith({
    int? id,
    String? title,
    String? description,
    int? viewForUser,
    int? secondForSkip,
    String? banner16,
    String? banner21,
    String? radius,
    DateTime? startDatetime,
    String? url,
    String? latitude,
    double? fillRate,
    String? longitude,
    bool? isActive,
    List<AdvertisingImageSet>? advertisingImagesetSet,
  }) {
    return RedvertisingCampaign(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      viewForUser: viewForUser ?? this.viewForUser,
      secondForSkip: secondForSkip ?? this.secondForSkip,
      banner16: banner16 ?? this.banner16,
      banner21: banner21 ?? this.banner21,
      radius: radius ?? this.radius,
      startDatetime: startDatetime ?? this.startDatetime,
      url: url ?? this.url,
      latitude: latitude ?? this.latitude,
      fillRate: fillRate ?? this.fillRate,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      advertisingImagesetSet:
          advertisingImagesetSet ?? this.advertisingImagesetSet,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    viewForUser,
    secondForSkip,
    banner16,
    banner21,
    radius,
    startDatetime,
    url,
    latitude,
    fillRate,
    longitude,
    isActive,
    advertisingImagesetSet,
  ];
}

/// Advertising image set for Zero Pensieri driving school campaigns
/// Matches iOS: AdvertisingImagesetSet struct
class AdvertisingImageSet extends Equatable {
  final int id;
  final String banner16;
  final String banner21;
  final String tag; // Format: "DS{drivingSchoolId}"

  const AdvertisingImageSet({
    required this.id,
    required this.banner16,
    required this.banner21,
    required this.tag,
  });

  factory AdvertisingImageSet.fromJson(Map<String, dynamic> json) {
    return AdvertisingImageSet(
      id: json['id'] as int,
      banner16: json['banner_16'] as String? ?? '',
      banner21: json['banner_21'] as String? ?? '',
      tag: json['tag'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'banner_16': banner16, 'banner_21': banner21, 'tag': tag};
  }

  /// Extract driving school ID from tag
  /// Matches iOS: getTag() method
  /// Tag format: "DS123" -> returns 123
  int? getDrivingSchoolId() {
    if (tag.startsWith('DS')) {
      final idString = tag.substring(2);
      return int.tryParse(idString);
    }
    return null;
  }

  /// Get the appropriate banner URL for the current device
  String getBannerForDevice({required bool hasNotch}) {
    return hasNotch ? banner21 : banner16;
  }

  AdvertisingImageSet copyWith({
    int? id,
    String? banner16,
    String? banner21,
    String? tag,
  }) {
    return AdvertisingImageSet(
      id: id ?? this.id,
      banner16: banner16 ?? this.banner16,
      banner21: banner21 ?? this.banner21,
      tag: tag ?? this.tag,
    );
  }

  @override
  List<Object?> get props => [id, banner16, banner21, tag];
}

/// Content type for tracking redvertising statistics
/// Matches iOS: RedvertisingContentType enum
enum RedvertisingContentType {
  seen(0), // Impression tracking
  clicked(1); // Click tracking

  final int value;
  const RedvertisingContentType(this.value);
}
