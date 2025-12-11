package com.who.mobile

import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val QUIZ_REMINDER_CHANNEL = "com.who.mobile/quizReminder"
        private const val REALM_MIGRATION_CHANNEL = "com.who.mobile/realm_migration"
        private const val AUTH_MIGRATION_CHANNEL = "com.who.mobile/auth_migration"
        private const val TAG = "MainActivity"
    }

    private var reminderChannel: MethodChannel? = null
    private lateinit var realmHelper: RealmMigrationHelper
    private lateinit var authMigrationHelper: SharedPreferencesMigrationHelper

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        Log.i(TAG, "===========================================")
        Log.i(TAG, "configureFlutterEngine CALLED - START")
        Log.i(TAG, "===========================================")

        super.configureFlutterEngine(flutterEngine)

        // Initialize migration helpers first
        initializeMigrationHelpers()

        // Setup all channels
        setupReminderChannel(flutterEngine)
        setupRealmMigrationChannel(flutterEngine)
        setupAuthMigrationChannel(flutterEngine)

        Log.i(TAG, "===========================================")
        Log.i(TAG, "configureFlutterEngine COMPLETED - END")
        Log.i(TAG, "===========================================")
    }

    private fun initializeMigrationHelpers() {
        try {
            Log.d(TAG, "Initializing migration helpers...")
            realmHelper = RealmMigrationHelper(this)
            Log.d(TAG, "RealmMigrationHelper initialized")

            authMigrationHelper = SharedPreferencesMigrationHelper(this)
            Log.d(TAG, "SharedPreferencesMigrationHelper initialized")
            Log.d(TAG, "Migration helpers initialized successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error initializing migration helpers: ${e.message}", e)
            // Initialize with defaults if needed
            try {
                if (!::realmHelper.isInitialized) {
                    realmHelper = RealmMigrationHelper(this)
                }
                if (!::authMigrationHelper.isInitialized) {
                    authMigrationHelper = SharedPreferencesMigrationHelper(this)
                }
            } catch (e2: Exception) {
                Log.e(TAG, "Failed to initialize helpers even with fallback: ${e2.message}", e2)
            }
        }
    }

    private fun setupReminderChannel(engine: FlutterEngine?) {
        if (engine == null) {
            Log.w(TAG, "FlutterEngine is null; delaying reminder channel setup")
            return
        }
        if (reminderChannel != null) {
            Log.d(TAG, "Reminder channel already initialized")
            return
        }

        Log.i(TAG, "Setting up quiz reminder method channel")

        try {
            reminderChannel = MethodChannel(
                engine.dartExecutor.binaryMessenger,
                QUIZ_REMINDER_CHANNEL
            ).apply {
                setMethodCallHandler { call, result ->
                    when (call.method) {
                        "scheduleReminder" -> {
                            val hour = call.argument<Int>("hour")
                            val minute = call.argument<Int>("minute")
                            val title = call.argument<String>("title")
                            val body = call.argument<String>("body")

                            if (hour == null || minute == null || title.isNullOrBlank() || body.isNullOrBlank()) {
                                result.error(
                                    "invalid_arguments",
                                    "Missing reminder scheduling arguments",
                                    null
                                )
                                return@setMethodCallHandler
                            }

                            val success = QuizReminderScheduler.scheduleReminder(
                                applicationContext,
                                hour,
                                minute,
                                title,
                                body
                            )
                            result.success(success)
                        }

                        "cancelReminder" -> {
                            QuizReminderScheduler.cancelReminder(applicationContext)
                            result.success(null)
                        }

                        "isReminderScheduled" -> {
                            val scheduled =
                                QuizReminderScheduler.isReminderScheduled(applicationContext)
                            result.success(scheduled)
                        }

                        "showTestNotification" -> {
                            val title = call.argument<String>("title")
                            val body = call.argument<String>("body")
                            val success = QuizReminderScheduler.showTestNotification(
                                applicationContext,
                                title,
                                body
                            )
                            result.success(success)
                        }

                        else -> result.notImplemented()
                    }
                }
            }
            Log.i(TAG, "Quiz reminder channel registered successfully")
        } catch (e: Exception) {
            Log.e(TAG, "ERROR registering quiz reminder channel: ${e.message}", e)
        }
    }

    private fun setupRealmMigrationChannel(flutterEngine: FlutterEngine) {
        try {
            Log.i(TAG, "===========================================")
            Log.i(TAG, "Registering Realm migration channel: $REALM_MIGRATION_CHANNEL")
            Log.i(TAG, "===========================================")

            if (!::realmHelper.isInitialized) {
                Log.e(TAG, "realmHelper not initialized! Initializing now...")
                realmHelper = RealmMigrationHelper(this)
            }

            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, REALM_MIGRATION_CHANNEL).setMethodCallHandler { call, result ->
                Log.d(TAG, "Realm migration channel method called: ${call.method}")
                try {
                    when (call.method) {
                        "findRealmFiles" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFiles = realmHelper.findRealmFiles()
                                result.success(realmFiles)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error finding Realm files: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateQuizzes" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val quizzesJson = realmHelper.migrateQuizzes(realmFilePath)
                                result.success(quizzesJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating quizzes: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateSheets" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val sheetsJson = realmHelper.migrateSheets(realmFilePath)
                                result.success(sheetsJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating sheets: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateQuizAnswers" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val answersJson = realmHelper.migrateQuizAnswers(realmFilePath)
                                result.success(answersJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating quiz answers: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateManualBooks" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val manualBooksJson = realmHelper.migrateManualBooks(realmFilePath)
                                result.success(manualBooksJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating manual books: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "inspectRealmFiles" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val inspectionJson = realmHelper.inspectRealmFiles()
                                result.success(inspectionJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error inspecting Realm files: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateUsers" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val usersJson = realmHelper.migrateUsers(realmFilePath)
                                result.success(usersJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating users: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateItemQuizzes" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val itemQuizzesJson = realmHelper.migrateItemQuizzes(realmFilePath)
                                result.success(itemQuizzesJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating ItemQuizzes: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateLicenseTypes" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val licenseTypesJson = realmHelper.migrateLicenseTypes(realmFilePath)
                                result.success(licenseTypesJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating LicenseTypes: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateManuals" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val manualsJson = realmHelper.migrateManuals(realmFilePath)
                                result.success(manualsJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating Manuals: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migrateTopics" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val topicsJson = realmHelper.migrateTopics(realmFilePath)
                                result.success(topicsJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating Topics: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "migratePictures" -> {
                            try {
                                if (!::realmHelper.isInitialized) {
                                    realmHelper = RealmMigrationHelper(this)
                                }
                                val realmFilePath = call.argument<String>("realmFilePath")
                                val picturesJson = realmHelper.migratePictures(realmFilePath)
                                result.success(picturesJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating Pictures: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        else -> {
                            Log.w(TAG, "Unknown Realm migration method: ${call.method}")
                            result.notImplemented()
                        }
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error in Realm migration channel handler: ${e.message}", e)
                    result.error("ERROR", e.message, null)
                }
            }
            Log.i(TAG, "===========================================")
            Log.i(TAG, "Realm migration channel registered successfully")
            Log.i(TAG, "===========================================")
        } catch (e: Exception) {
            Log.e(TAG, "===========================================")
            Log.e(TAG, "ERROR registering Realm migration channel: ${e.message}", e)
            Log.e(TAG, "===========================================")
        }
    }

    private fun setupAuthMigrationChannel(flutterEngine: FlutterEngine) {
        try {
            Log.i(TAG, "===========================================")
            Log.i(TAG, "Registering auth migration channel: $AUTH_MIGRATION_CHANNEL")
            Log.i(TAG, "===========================================")

            if (!::authMigrationHelper.isInitialized) {
                Log.e(TAG, "authMigrationHelper not initialized! Initializing now...")
                authMigrationHelper = SharedPreferencesMigrationHelper(this)
            }

            val authBinaryMessenger = flutterEngine.dartExecutor.binaryMessenger
            MethodChannel(authBinaryMessenger, AUTH_MIGRATION_CHANNEL).setMethodCallHandler { call, result ->
                Log.d(TAG, "Auth migration channel method called: ${call.method}")
                try {
                    when (call.method) {
                        "migrateAuthData" -> {
                            try {
                                Log.d(TAG, "Migrating auth data...")
                                if (!::authMigrationHelper.isInitialized) {
                                    Log.e(TAG, "authMigrationHelper not initialized in migrateAuthData!")
                                    authMigrationHelper = SharedPreferencesMigrationHelper(this)
                                }
                                val authDataJson = authMigrationHelper.migrateAuthData()
                                if (authDataJson != null) {
                                    Log.d(TAG, "Auth data migrated successfully")
                                    result.success(authDataJson)
                                } else {
                                    Log.d(TAG, "No auth data found")
                                    result.success(null)
                                }
                            } catch (e: Exception) {
                                Log.e(TAG, "Error migrating auth data: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "hasOldAppAuthData" -> {
                            try {
                                Log.d(TAG, "Checking for old app auth data...")
                                if (!::authMigrationHelper.isInitialized) {
                                    Log.e(TAG, "authMigrationHelper not initialized in hasOldAppAuthData!")
                                    authMigrationHelper = SharedPreferencesMigrationHelper(this)
                                }
                                val hasAuthData = authMigrationHelper.hasOldAppAuthData()
                                Log.d(TAG, "Has old app auth data: $hasAuthData")
                                result.success(hasAuthData)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error checking auth data: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        "inspectOldAppSharedPreferences" -> {
                            try {
                                Log.d(TAG, "Inspecting old app SharedPreferences...")
                                if (!::authMigrationHelper.isInitialized) {
                                    Log.e(TAG, "authMigrationHelper not initialized in inspectOldAppSharedPreferences!")
                                    authMigrationHelper = SharedPreferencesMigrationHelper(this)
                                }
                                val inspectionJson = authMigrationHelper.inspectOldAppSharedPreferences()
                                result.success(inspectionJson)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error inspecting SharedPreferences: ${e.message}", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                        else -> {
                            Log.w(TAG, "Unknown auth migration method: ${call.method}")
                            result.notImplemented()
                        }
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error in auth migration channel handler: ${e.message}", e)
                    result.error("ERROR", e.message, null)
                }
            }
            Log.i(TAG, "===========================================")
            Log.i(TAG, "Auth migration channel registered successfully")
            Log.i(TAG, "===========================================")
        } catch (e: Exception) {
            Log.e(TAG, "===========================================")
            Log.e(TAG, "ERROR registering auth migration channel: ${e.message}", e)
            Log.e(TAG, "===========================================")
        }
    }
}
