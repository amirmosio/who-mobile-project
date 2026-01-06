import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/maintenance_guide/maintenance_data_model.dart';

@injectable
class MaintenanceRepository {
  MaintenanceDataModel? _cachedData;

  Future<MaintenanceDataModel> loadMaintenanceData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/maintenance_description/maintenance_steps.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData = MaintenanceDataModel.fromJson(jsonData);
      return _cachedData!;
    } catch (e) {
      throw Exception('Failed to load maintenance data: $e');
    }
  }

  String getImagePath(String filename) {
    return 'assets/maintenance_description/images/$filename';
  }

  void clearCache() {
    _cachedData = null;
  }
}
