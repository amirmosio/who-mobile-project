import 'dart:math';

import 'package:dio/dio.dart';
import 'package:who_mobile_project/general/constants/api_error_types.dart';
import 'package:who_mobile_project/repository/repo_state.dart';

class GeneralUtil {
  static GeneralUtil? utility;

  static GeneralUtil getInstance() {
    utility ??= GeneralUtil();
    return utility!;
  }

  RepositoryException getHttpRepositoryException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return RepositoryException(
        error: ErrorType.connectionTimeout,
        message: null,
      );
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return RepositoryException(
        error: ErrorType.receiveTimeout,
        message: null,
      );
    } else if (error.type == DioExceptionType.connectionError) {
      return RepositoryException(
        error: ErrorType.communicationProblems,
        message: null,
      );
    } else if (error.response != null) {
      return RepositoryException(error: ErrorType.notHandled, message: null);
    } else {
      return RepositoryException(error: ErrorType.notHandled, message: null);
    }
  }
}

class Pair<A, B> {
  final A first;
  final B second;

  const Pair(this.first, this.second);
}

double sigmoidNormalization(
  double value,
  double max,
  double avg, {
  double steepness = 0.5,
  double startOpacity = 0.2,
}) {
  value = (value - avg);
  return min(1, startOpacity + 1 / (1 + exp(-1 * steepness * value)));
}

/// Parse version string like "1.0.2" or "v1.0.2" to integer like 102
/// This allows for semantic version comparison
int parseVersionString(String version) {
  // Remove 'v' prefix if present
  String cleanVersion = version.startsWith('v')
      ? version.substring(1)
      : version;

  // Split by dots and convert to integer
  List<String> parts = cleanVersion.split('.');
  if (parts.length >= 3) {
    try {
      int major = int.parse(parts[0]);
      int minor = int.parse(parts[1]);
      int patch = int.parse(parts[2]);
      return major * 100 + minor * 10 + patch;
    } catch (e) {
      return 0;
    }
  }
  return 0;
}
