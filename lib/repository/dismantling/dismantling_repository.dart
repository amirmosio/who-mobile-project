import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/dismantling/dismantling_data_model.dart';

@injectable
class DismantlingRepository {
  final Map<String, DismantlingDataModel> _cachedData = {};

  Future<DismantlingDataModel> loadDismantlingData({
    String localeCode = 'en',
  }) async {
    if (_cachedData.containsKey(localeCode)) {
      return _cachedData[localeCode]!;
    }

    try {
      final suffix = localeCode == 'en' ? '' : '_$localeCode';
      final String jsonString = await rootBundle.loadString(
        'assets/dismantelling_description/dismantling_steps$suffix.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData[localeCode] = DismantlingDataModel.fromJson(jsonData);
      return _cachedData[localeCode]!;
    } catch (e) {
      throw Exception('Failed to load dismantling data: $e');
    }
  }

  String getImagePath(String filename) {
    return 'assets/dismantelling_description/images/$filename';
  }

  void clearCache() {
    _cachedData.clear();
  }
}
