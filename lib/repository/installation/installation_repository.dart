import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/installation/installation_data_model.dart';

@injectable
class InstallationRepository {
  final Map<String, InstallationDataModel> _cachedData = {};

  Future<InstallationDataModel> loadInstallationData({
    String localeCode = 'en',
  }) async {
    if (_cachedData.containsKey(localeCode)) {
      return _cachedData[localeCode]!;
    }

    try {
      final suffix = localeCode == 'en' ? '' : '_$localeCode';
      final String jsonString = await rootBundle.loadString(
        'assets/installation_description/installation_steps$suffix.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData[localeCode] = InstallationDataModel.fromJson(jsonData);
      return _cachedData[localeCode]!;
    } catch (e) {
      throw Exception('Failed to load installation data: $e');
    }
  }

  String getImagePath(String filename) {
    return 'assets/installation_description/images/$filename';
  }

  void clearCache() {
    _cachedData.clear();
  }
}
