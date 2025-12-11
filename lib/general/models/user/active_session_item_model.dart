class ActiveSessionItemModel {
  final String id;
  final DeviceInfo deviceInfo;
  final String ipAddress;
  final LocationInfo locationInfo;
  final DateTime lastLogin;
  final bool isCurrent;

  ActiveSessionItemModel({
    required this.id,
    required this.deviceInfo,
    required this.ipAddress,
    required this.locationInfo,
    required this.lastLogin,
    required this.isCurrent,
  });

  factory ActiveSessionItemModel.fromJson(Map<String, dynamic> json) {
    return ActiveSessionItemModel(
      id: json['id'] ?? '',
      deviceInfo: DeviceInfo.fromJson(json['device_info']),
      ipAddress: json['ip_address'] ?? '',
      locationInfo: LocationInfo.fromJson(json['location_info']),
      lastLogin: DateTime.parse(json['last_login']),
      isCurrent: json['is_current'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_info': deviceInfo.toJson(),
      'ip_address': ipAddress,
      'location_info': locationInfo.toJson(),
      'last_login': lastLogin.toIso8601String(),
      'is_current': isCurrent,
    };
  }
}

class DeviceInfo {
  final String deviceName;
  final String deviceType;
  final String browser;
  final String osName;

  bool get isMobile {
    return deviceType.toLowerCase() == 'mobile';
  }

  bool get isWeb {
    return deviceType.toLowerCase() == 'web';
  }

  DeviceInfo({
    required this.deviceName,
    required this.deviceType,
    required this.browser,
    required this.osName,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceName: json['device_name'] ?? '',
      deviceType: json['device_type'] ?? '',
      browser: json['browser'] ?? '',
      osName: json['os_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_name': deviceName,
      'device_type': deviceType,
      'browser': browser,
      'os_name': osName,
    };
  }
}

class LocationInfo {
  final String? country;
  final String? city;
  final String locationDisplay;

  LocationInfo({this.country, this.city, required this.locationDisplay});

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      country: json['country'],
      city: json['city'],
      locationDisplay: json['location_display'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'city': city,
      'location_display': locationDisplay,
    };
  }
}
