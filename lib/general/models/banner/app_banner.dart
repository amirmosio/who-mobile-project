import 'package:equatable/equatable.dart';

/// Model representing marketing banners displayed across the app.
class AppBanner extends Equatable {
  final int id;
  final String? image;
  final String? url;
  final String? redirectUrl;
  final String name;
  final BannerPlacement placement;
  final bool isActive;
  final DateTime createdDateTime;
  final DateTime modifiedDateTime;

  const AppBanner({
    required this.id,
    required this.image,
    required this.url,
    required this.redirectUrl,
    required this.name,
    required this.placement,
    required this.isActive,
    required this.createdDateTime,
    required this.modifiedDateTime,
  });

  factory AppBanner.fromJson(Map<String, dynamic> json) {
    return AppBanner(
      id: json['id'] as int,
      image: json['image'] as String?,
      url: json['url'] as String?,
      redirectUrl: json['redirect_url'] as String?,
      name: json['name'] as String? ?? '',
      placement: BannerPlacement.fromString(json['placement'] as String),
      isActive: json['is_active'] as bool? ?? false,
      createdDateTime: DateTime.parse(json['created_datetime'] as String),
      modifiedDateTime: DateTime.parse(json['modified_datetime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'url': url,
      'redirect_url': redirectUrl,
      'name': name,
      'placement': placement.value,
      'is_active': isActive,
      'created_datetime': createdDateTime.toIso8601String(),
      'modified_datetime': modifiedDateTime.toIso8601String(),
    };
  }

  /// Returns the best available asset for rendering the banner.
  /// The backend guarantees that at least one between image and url is present.
  String? get primaryAsset => image?.isNotEmpty == true ? image : url;

  /// Returns true if the banner has a valid redirect URL for navigation.
  bool get hasRedirectUrl => redirectUrl != null && redirectUrl!.isNotEmpty;

  AppBanner copyWith({
    int? id,
    String? image,
    String? url,
    String? redirectUrl,
    String? name,
    BannerPlacement? placement,
    bool? isActive,
    DateTime? createdDateTime,
    DateTime? modifiedDateTime,
  }) {
    return AppBanner(
      id: id ?? this.id,
      image: image ?? this.image,
      url: url ?? this.url,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      name: name ?? this.name,
      placement: placement ?? this.placement,
      isActive: isActive ?? this.isActive,
      createdDateTime: createdDateTime ?? this.createdDateTime,
      modifiedDateTime: modifiedDateTime ?? this.modifiedDateTime,
    );
  }

  @override
  List<Object?> get props => [
    id,
    image,
    url,
    redirectUrl,
    name,
    placement,
    isActive,
    createdDateTime,
    modifiedDateTime,
  ];
}

enum BannerPlacement {
  guides('guides'),
  live('live'),
  quiz('quiz'),
  dashboard('dashboard');

  final String value;

  const BannerPlacement(this.value);

  static BannerPlacement fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'guides':
        return BannerPlacement.guides;
      case 'live':
        return BannerPlacement.live;
      case 'quiz':
        return BannerPlacement.quiz;
      case 'dashboard':
        return BannerPlacement.dashboard;
      default:
        throw ArgumentError('Unsupported banner placement: $raw');
    }
  }
}
