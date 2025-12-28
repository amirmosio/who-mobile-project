import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/models/idtm/idtm_facility.dart';

/// Service to load IDTM guide content from local JSON assets
@injectable
class IdtmAssetLoader {
  static const String _facilitiesPath = 'assets/idtm/data/facilities.json';

  /// Load all available facilities
  Future<List<IdtmFacility>> loadFacilities() async {
    try {
      final String jsonString = await rootBundle.loadString(_facilitiesPath);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => IdtmFacility.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return empty list if file doesn't exist yet
      // This allows app to run before assets are prepared
      return [];
    }
  }

  /// Load a specific facility by ID
  Future<IdtmFacility?> loadFacilityById(String facilityId) async {
    final facilities = await loadFacilities();
    try {
      return facilities.firstWhere((f) => f.id == facilityId);
    } catch (e) {
      return null;
    }
  }

  /// Check if asset exists
  Future<bool> assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      return false;
    }
  }
}
