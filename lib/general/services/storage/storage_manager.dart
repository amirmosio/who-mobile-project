import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/services/storage/base_storage.dart';
import 'package:who_mobile_project/general/services/storage/mixins/app_state_storage_mixin.dart';
import 'package:who_mobile_project/general/services/storage/mixins/auth_storage_mixin.dart';
import 'package:who_mobile_project/general/services/storage/mixins/config_storage_mixin.dart';
import 'package:who_mobile_project/general/services/storage/mixins/database_migration_storage_mixin.dart';
import 'package:who_mobile_project/general/services/storage/mixins/guest_storage_mixin.dart';
import 'package:who_mobile_project/general/services/storage/mixins/preferences_storage_mixin.dart';
import 'package:who_mobile_project/general/services/storage/mixins/redvertising_storage_mixin.dart';
import 'package:who_mobile_project/general/services/storage/mixins/tag_book_storage_mixin.dart';

@singleton
class StorageManager extends BaseStorage
    with
        AuthStorageMixin,
        GuestStorageMixin,
        PreferencesStorageMixin,
        AppStateStorageMixin,
        DatabaseMigrationStorageMixin,
        ConfigStorageMixin,
        RedvertisingStorageMixin,
        TagBookStorageMixin {
  Future<void> initializeStorage() async {
    await initialize();
  }

  Future<void> removeUserRelatedInfo() async {
    await removeUserAuthData();
  }

  // Future<void> resetStorages() async {
  //   await removeUserAuthData();
  //   await removeGuestStoredAccount();
  //   await sharedPreferences.clear();
  // }
}
