import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/maintenance_guide/maintenance_data_model.dart';

@injectable
class MaintenanceRepository {
  final Map<String, MaintenanceDataModel> _cachedData = {};

  Future<MaintenanceDataModel> loadMaintenanceData({
    String localeCode = 'en',
  }) async {
    if (_cachedData.containsKey(localeCode)) {
      return _cachedData[localeCode]!;
    }

    try {
      final suffix = localeCode == 'en' ? '' : '_$localeCode';
      final String jsonString = await rootBundle.loadString(
        'assets/maintenance_description/maintenance_steps$suffix.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData[localeCode] = MaintenanceDataModel.fromJson(jsonData);
      return _cachedData[localeCode]!;
    } catch (e) {
      throw Exception('Failed to load maintenance data: $e');
    }
  }

  String getImagePath(String filename) {
    return 'assets/maintenance_description/images/$filename';
  }

  void clearCache() {
    _cachedData.clear();
  }
}
