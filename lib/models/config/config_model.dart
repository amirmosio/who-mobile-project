import 'package:json_annotation/json_annotation.dart';

part 'config_model.g.dart';

enum ConfigType {
  @JsonValue(0)
  boolean,
  @JsonValue(1)
  int,
  @JsonValue(2)
  float,
  @JsonValue(3)
  string,
  @JsonValue(4)
  array,
  @JsonValue(5)
  arrayInt,
  @JsonValue(6)
  arrayString,
  @JsonValue(7)
  long,
}

@JsonSerializable()
class ConfigModel {
  final int id;
  final String key;
  final String value;
  final ConfigType type;
  @JsonKey(name: 'is_active')
  final bool isActive;

  const ConfigModel({
    required this.id,
    required this.key,
    required this.value,
    required this.type,
    required this.isActive,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigModelToJson(this);

  /// Parse the value based on its type
  T? getParsedValue<T>() {
    switch (type) {
      case ConfigType.boolean:
        return (value.toLowerCase() == 'true') as T?;
      case ConfigType.int:
        return int.tryParse(value) as T?;
      case ConfigType.float:
        return double.tryParse(value) as T?;
      case ConfigType.string:
        return value as T?;
      case ConfigType.array:
        return value
                .replaceAll(' ', '')
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((e) => e.trim())
                .toList()
            as T?;
      case ConfigType.arrayInt:
        return value
                .replaceAll(' ', '')
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((e) => int.tryParse(e.trim()))
                .where((e) => e != null)
                .cast<int>()
                .toList()
            as T?;
      case ConfigType.arrayString:
        return value
                .replaceAll(' ', '')
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', '')
                .split(',')
                .map((e) => e.trim())
                .toList()
            as T?;
      case ConfigType.long:
        return double.tryParse(value) as T?;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          key == other.key &&
          value == other.value &&
          type == other.type &&
          isActive == other.isActive;

  @override
  int get hashCode =>
      id.hashCode ^
      key.hashCode ^
      value.hashCode ^
      type.hashCode ^
      isActive.hashCode;

  @override
  String toString() {
    return 'ConfigModel{id: $id, key: $key, value: $value, type: $type, isActive: $isActive}';
  }
}

/// Configuration keys matching iOS implementation
enum ConfigKeys {
  contestStartTimestamp('contest_start_timestamp'),
  contestCloseTimestamp('contest_close_timestamp'),
  contestEndTimestamp('contest_end_timestamp'),
  contestLandingUrl('contest_landing_url'),
  contestMessageClosed('contest_message_closed'),
  contestBannerImage('contest_banner_image'),
  contestCardImage('contest_card_image'),
  contestCardCountdownImage('contest_card_countdown_image'),
  noAdsAppOpeningsCount('ios_ads_no_ads_app_openings_count'),
  fewAdsAppOpeningsCount('ios_ads_few_ads_app_openings_count'),
  fewAdsDivider('ios_ads_few_ads_divider'),
  interstitialsPriority('ios_ads_interstitials_priority'),
  interstitialsDelaySeconds('ios_ads_interstitials_delay_seconds'),
  magikLinkiOS('magik_link_ios'),
  showCheckIn('show_check_in'),
  promoBannerIsActive('key_promo_banner_is_active'),
  promoBannerImage('key_promo_banner_image'),
  promoBannerLink('key_promo_banner_link'),
  promoBannerBackgroundColor('key_promo_banner_background_color'),
  promoSectionLink('key_promo_section_link'),
  promoInSchoolLink('key_promo_in_school_link'),
  promoInSchoolimage('key_promo_in_school_image'),
  quizTagbookImage('key_quiz_tagbook_image'),
  quizTagbookText('key_quiz_tagbook_text'),
  quizTagbookCta('key_quiz_tagbook_cta'),
  quizTagbookCtaLink('key_quiz_tagbook_cta_link'),
  bannerOffertaRiservataPiccola('key_banner_offerta_riservata_piccola'),
  bannerOffertaRiservata('key_banner_offerta_riservata');

  const ConfigKeys(this.key);

  final String key;

  /// List of all banner-related config keys
  static const List<ConfigKeys> bannerKeys = [
    promoBannerIsActive,
    promoBannerImage,
    promoBannerLink,
    promoBannerBackgroundColor,
    contestBannerImage,
    bannerOffertaRiservataPiccola,
    bannerOffertaRiservata,
  ];
}
