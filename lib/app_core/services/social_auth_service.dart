import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:who_mobile_project/general/models/login/social_login_request.dart';

@injectable
class SocialAuthService {
  static bool _googleInitialized = false;

  final Logger _logger = Logger();

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    try {
      await GoogleSignIn.instance.initialize();
      _googleInitialized = true;
    } catch (e) {
      _logger.e('GoogleSignIn initialize failed: $e');
    }
  }

  /// Generates a cryptographically secure random nonce for Apple Sign In
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Sign in with Google and return GoogleAuthRequest for new API
  Future<GoogleAuthRequest?> signInWithGoogleForSocialLogin() async {
    await _ensureGoogleInitialized();
    final GoogleSignInAccount account = await GoogleSignIn.instance
        .authenticate(scopeHint: ['email', 'profile']);

    final GoogleSignInAuthentication googleAuth = account.authentication;

    // Extract firstname and surname from displayName
    String firstname = '';
    String surname = '';

    if (account.displayName != null && account.displayName!.isNotEmpty) {
      final nameParts = account.displayName!.trim().split(' ');
      if (nameParts.isNotEmpty) {
        firstname = nameParts.first;
        if (nameParts.length > 1) {
          surname = nameParts.skip(1).join(' ');
        }
      }
    }

    return GoogleAuthRequest(
      token: googleAuth.idToken ?? '',
      firstname: firstname,
      surname: surname,
    );
  }

  /// Sign in with Apple for new social login API (returns AppleAuthRequest)
  Future<AppleAuthRequest?> signInWithAppleForSocialLogin() async {
    if (!Platform.isIOS) {
      throw UnsupportedError('Apple Sign In is only available on iOS');
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    String firstname = appleCredential.givenName ?? '';
    String surname = appleCredential.familyName ?? '';

    return AppleAuthRequest(
      token: appleCredential.identityToken ?? '',
      firstname: firstname,
      surname: surname,
    );
  }

  /// Check if Google Sign In is available
  Future<bool> isGoogleSignInAvailable() async {
    try {
      // On Android, check if Google Play Services is available
      if (Platform.isAndroid) {
        return true; // Assume it's available, will fail gracefully if not
      }
      // On iOS, always available
      return true;
    } catch (error) {
      return false;
    }
  }

  /// Check if Apple Sign In is available
  Future<bool> isAppleSignInAvailable() async {
    try {
      if (!Platform.isIOS) {
        return false;
      }
      return await SignInWithApple.isAvailable();
    } catch (error) {
      return false;
    }
  }

  /// Sign in with Facebook for new social login API (returns FacebookAuthRequest)
  Future<FacebookAuthRequest?> signInWithFacebookForSocialLogin() async {
    // First, logout to clear any cached tokens/permissions
    await FacebookAuth.instance.logOut();
    _logger.d('Facebook: Cleared cached session');

    // Request email and public profile permissions explicitly
    // Note: 'email' permission must be approved by Facebook if app is in development mode
    // IMPORTANT: Use LoginTracking.enabled to get ClassicToken (not LimitedToken)
    // which allows us to see granted/declined permissions
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile'],
    );

    if (result.status == LoginStatus.success) {
      // Get the access token
      final AccessToken? accessToken = result.accessToken;
      if (accessToken == null || accessToken.tokenString.isEmpty) {
        _logger.w('Facebook login succeeded but no access token received');
        return null;
      }

      // Log token info for debugging
      _logger.d(
        'Facebook access token received: ${accessToken.tokenString.substring(0, 20)}...',
      );

      // Get user data to extract name, email, and facebook ID
      final userData = await FacebookAuth.instance.getUserData(
        fields: 'id,first_name,last_name,name',
      );

      // Log the raw user data for debugging
      _logger.d('Facebook user data received: $userData');

      // Extract required fields
      String firstname = userData['first_name']?.toString() ?? '';
      String surname = userData['last_name']?.toString() ?? '';

      // Fallback: try to parse from full name if first/last are not available
      if (firstname.isEmpty && surname.isEmpty) {
        final fullName = userData['name']?.toString() ?? '';
        if (fullName.isNotEmpty) {
          final nameParts = fullName.trim().split(' ');
          if (nameParts.isNotEmpty) {
            firstname = nameParts.first;
            if (nameParts.length > 1) {
              surname = nameParts.skip(1).join(' ');
            }
          }
        }
      }

      return FacebookAuthRequest(
        token: accessToken.tokenString,
        firstname: firstname,
        surname: surname,
      );
    } else if (result.status == LoginStatus.cancelled) {
      _logger.i('Facebook login was cancelled by user');
      return null;
    } else {
      _logger.w('Facebook login failed with status: ${result.status}');
      return null;
    }
  }

  /// Check if Facebook Sign In is available
  Future<bool> isFacebookSignInAvailable() async {
    try {
      // Facebook Auth is generally available on both iOS and Android
      // if the SDK is properly configured
      return true;
    } catch (error) {
      _logger.e('Error checking Facebook availability: $error');
      return false;
    }
  }
}
