import 'dart:convert';
import 'package:who_mobile_project/general/models/registration/guest_registration_request.dart';
import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for guest user storage operations
mixin GuestStorageMixin on BaseStorage {
  // Storage keys
  static const _guestUserStoredAccountKey = "guest_user_stored_account";

  /// Set guest stored account (persistent - never deleted automatically)
  Future<void> setGuestStoredAccount(
    GuestRegistrationModel guestAccount,
  ) async {
    await secureStorage.write(
      key: _guestUserStoredAccountKey,
      value: jsonEncode(guestAccount.toJson()),
    );
  }

  /// Get guest stored account
  Future<GuestRegistrationModel?> getGuestStoredAccount() async {
    try {
      final guestAccountString = await secureStorage.read(
        key: _guestUserStoredAccountKey,
      );
      if (guestAccountString != null && guestAccountString.isNotEmpty) {
        final guestAccountData =
            jsonDecode(guestAccountString) as Map<String, dynamic>;
        return GuestRegistrationModel.fromJson(guestAccountData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
