import 'package:jwt_decoder/jwt_decoder.dart';

class TokenUtils {
  TokenUtils._privateConstructor();

  static bool checkIfJWTTokenWillBeValidForDuration(
    String token, {
    Duration duration = const Duration(seconds: 60),
  }) {
    DateTime expirationDate = JwtDecoder.getExpirationDate(token);
    DateTime oneMinAgo = DateTime.now().add(duration);
    if (oneMinAgo.isAfter(expirationDate)) {
      return false;
    }
    return true;
  }

  /// Check if a refresh token is still valid (not expired)
  static bool isRefreshTokenValid(String? refreshToken) {
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      // Check if refresh token is not expired
      return !JwtDecoder.isExpired(refreshToken);
    } catch (e) {
      // If there's any error decoding the token, consider it invalid
      return false;
    }
  }
}
