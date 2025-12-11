import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// REST client specifically for AI service requests
/// No interceptors, no authentication, simple HTTP client
@injectable
class AiRestClient {
  late final Dio _dio;
  late final Logger _logger;

  AiRestClient() {
    _logger = Logger();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://ai.guidaevai.com/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  /// Get other images for a manual from AI service
  Future<List<String>> getManualOtherImages(int manualId) async {
    try {
      final response = await _dio.post(
        'api/chat-ai/get_other_images/',
        data: {'manual_id': manualId},
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> images = response.data['images'] ?? [];

        // Filter out .DS_Store files and return valid image URLs
        return images
            .where((url) => url is String && !url.contains('.DS_Store'))
            .cast<String>()
            .toList();
      }

      return [];
    } catch (e) {
      _logger.e(
        'AI API: Error fetching manual images for ID $manualId',
        error: e,
      );
      return [];
    }
  }
}
