import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/facility_use/facility_use_data_model.dart';

@injectable
class FacilityUseRepository {
  final Map<String, FacilityUseDataModel> _cachedData = {};

  Future<FacilityUseDataModel> loadFacilityUseData({
    String localeCode = 'en',
  }) async {
    if (_cachedData.containsKey(localeCode)) {
      return _cachedData[localeCode]!;
    }

    try {
      final suffix = localeCode == 'en' ? '' : '_$localeCode';
      final String jsonString = await rootBundle.loadString(
        'assets/facility_use_description/facility_use_steps$suffix.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData[localeCode] = FacilityUseDataModel.fromJson(jsonData);
      return _cachedData[localeCode]!;
    } catch (e) {
      throw Exception('Failed to load facility use data: $e');
    }
  }

  String getImagePath(String filename) {
    return 'assets/facility_use_description/images/$filename';
  }

  void clearCache() {
    _cachedData.clear();
  }
}
