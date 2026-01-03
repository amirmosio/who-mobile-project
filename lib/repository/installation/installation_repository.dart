import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/installation/installation_data_model.dart';

@injectable
class InstallationRepository {
  InstallationDataModel? _cachedData;

  Future<InstallationDataModel> loadInstallationData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'project_assets/project_feature_description/installation_description/installation_steps.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData = InstallationDataModel.fromJson(jsonData);
      return _cachedData!;
    } catch (e) {
      throw Exception('Failed to load installation data: $e');
    }
  }

  String getImagePath(String filename) {
    return 'project_assets/project_feature_description/installation_description/installation_steps_images/$filename';
  }

  void clearCache() {
    _cachedData = null;
  }
}
