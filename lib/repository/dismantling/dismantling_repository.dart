import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/dismantling/dismantling_data_model.dart';

@injectable
class DismantlingRepository {
  DismantlingDataModel? _cachedData;

  Future<DismantlingDataModel> loadDismantlingData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/dismantelling_description/dismantling_steps.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData = DismantlingDataModel.fromJson(jsonData);
      return _cachedData!;
    } catch (e) {
      throw Exception('Failed to load dismantling data: $e');
    }
  }

  String getImagePath(String filename) {
    return 'assets/dismantelling_description/images/$filename';
  }

  void clearCache() {
    _cachedData = null;
  }
}
