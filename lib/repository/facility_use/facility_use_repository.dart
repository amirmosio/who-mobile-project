import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/facility_use/facility_use_data_model.dart';

@injectable
class FacilityUseRepository {
  FacilityUseDataModel? _cachedData;

  Future<FacilityUseDataModel> loadFacilityUseData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/facility_use_description/facility_use_steps.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData = FacilityUseDataModel.fromJson(jsonData);
      return _cachedData!;
    } catch (e) {
      throw Exception('Failed to load facility use data: $e');
    }
  }

  String getImagePath(String filename) {
    return 'assets/facility_use_description/images/$filename';
  }

  void clearCache() {
    _cachedData = null;
  }
}
