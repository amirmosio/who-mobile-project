package com.who.mobile

import android.content.Context
import android.util.Log
import io.realm.DynamicRealm
import io.realm.DynamicRealmObject
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.RealmSchema
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.security.MessageDigest
import android.util.Base64

/**
 * Helper class to migrate data from Realm database (old app) to Drift database (new Flutter app)
 *
 * This class reads Realm files and exports data as JSON that can be consumed by Flutter
 */
class RealmMigrationHelper(private val context: Context) {
    companion object {
        private const val TAG = "RealmMigrationHelper"
        private const val CHANNEL_NAME = "com.bokapp.quizpatente/realm_migration"
        private const val ENC_KEY_GEV = "*REDDOAK.guidaevai.quizpatente.Z4QQQbatman*"
    }

    /**
     * Generate the encryption key from the string using the same algorithm as the old app
     * This matches the Java implementation: Utils.getByteKey(ProjectConsts.ENC_KEY_GEV)
     *
     * Java code:
     *   String md5 = md5(string);  // Returns hex string (32 chars, e.g., "a1b2c3d4...")
     *   byte[] temp = Base64.decode(md5, Base64.DEFAULT);  // Decode hex string as Base64
     *   // Then expand to 64 bytes
     *
     * The old app's md5() method returns a hex string, which is then Base64-decoded.
     * This is unusual but we need to match it exactly.
     */
    private fun getByteKey(string: String): ByteArray {
        val key = ByteArray(64)

        // Step 1: MD5 hash the string (use UTF-8 encoding to match Java's default)
        val md = MessageDigest.getInstance("MD5")
        val md5Bytes = md.digest(string.toByteArray(Charsets.UTF_8))

        // Step 2: Convert MD5 bytes to hex string (matching old app's md5() method)
        // The old app's md5() method returns a hex string like "a1b2c3d4e5f6..."
        val hexString = StringBuilder()
        for (byte in md5Bytes) {
            val hex = Integer.toHexString(0xFF and byte.toInt())
            if (hex.length < 2) {
                hexString.append('0')
            }
            hexString.append(hex)
        }

        // Step 3: Base64 decode the hex string (as the old app does)
        // This is unusual but matches the old app's behavior
        val temp = Base64.decode(hexString.toString(), Base64.DEFAULT)

        // Step 4: Expand to 64 bytes (padding with -temp.length or i if needed)
        // This matches the Java code exactly
        for (i in key.indices) {
            try {
                key[i] = temp[i]
            } catch (e: IndexOutOfBoundsException) {
                // Java code: if (i % 2 == 0) { key[i] = (byte) -temp.length; } else { key[i] = (byte) i; }
                if (i % 2 == 0) {
                    key[i] = (-temp.size).toByte()
                } else {
                    key[i] = i.toByte()
                }
            }
        }

        // Debug: Log key generation details
        Log.d(TAG, "Generated encryption key - MD5 bytes length: ${md5Bytes.size}, hex string length: ${hexString.length}, temp length: ${temp.size}, key length: ${key.size}")
        Log.d(TAG, "Hex string: ${hexString.toString().take(32)}")
        Log.d(TAG, "First 8 temp bytes: ${temp.take(8).joinToString(", ")}")
        Log.d(TAG, "First 8 key bytes: ${key.take(8).joinToString(", ")}")
        Log.d(TAG, "Last 8 key bytes: ${key.takeLast(8).joinToString(", ")}")

        return key
    }

    /**
     * Get the encryption key for the Realm database
     */
    private fun getEncryptionKey(): ByteArray {
        return getByteKey(ENC_KEY_GEV)
    }

    /**
     * Check if a Realm file is encrypted by trying to open it without a key
     * Returns true if the file exists and is likely encrypted
     */
    private fun isEncryptedRealmFile(realmFilePath: String): Boolean {
        val realmFile = File(realmFilePath)
        if (!realmFile.exists()) return false

        // Files that are known to be encrypted
        val encryptedFileNames = listOf("AB", "AB.v10.backup.realm")
        val fileName = realmFile.name

        return encryptedFileNames.any { fileName.contains(it, ignoreCase = true) }
    }

    /**
     * Find Realm database files in the app's files directory
     * Realm files are typically stored in the app's files directory
     * with names like: default.realm, <license_type>_<language>.realm, etc.
     */
    fun findRealmFiles(): List<String> {
        val realmFiles = mutableListOf<String>()
        try {
            val filesDir = context.filesDir
            val files = filesDir.listFiles()

            if (files != null) {
                for (file in files) {
                    if (file.isFile) {
                        // Skip lock files (they're not Realm databases)
                        if (file.name.endsWith(".lock")) {
                            continue
                        }

                        // Check for .realm extension files
                        if (file.name.endsWith(".realm")) {
                            realmFiles.add(file.absolutePath)
                            Log.d(TAG, "Found Realm file: ${file.absolutePath}")
                        }
                        // Also check for known Realm file names without extension
                        // (e.g., "AB", "SchoolRealmConfiguration", etc.)
                        else if (file.name.matches(Regex("^[A-Z][A-Za-z]*$")) ||
                                 file.name.contains("Realm", ignoreCase = true) ||
                                 file.name == "AB" ||
                                 file.name == "SchoolRealmConfiguration") {
                            // Verify it's a Realm file by checking if it has a .lock file
                            val lockFile = File(file.parent, "${file.name}.lock")
                            if (lockFile.exists() || file.length() > 1000) { // Realm files are typically > 1KB
                                realmFiles.add(file.absolutePath)
                                Log.d(TAG, "Found Realm file (no extension): ${file.absolutePath}")
                            }
                        }
                    }
                }
            }

            // Also check in the parent directory (for old app data if same package)
            val parentDir = File(filesDir.parent)
            if (parentDir.exists() && parentDir.isDirectory) {
                val parentFiles = parentDir.listFiles()
                if (parentFiles != null) {
                    for (file in parentFiles) {
                        if (file.isFile) {
                            // Skip lock files (they're not Realm databases)
                            if (file.name.endsWith(".lock")) {
                                continue
                            }

                            // Check for .realm extension files
                            if (file.name.endsWith(".realm")) {
                                realmFiles.add(file.absolutePath)
                                Log.d(TAG, "Found Realm file in parent: ${file.absolutePath}")
                            }
                            // Also check for known Realm file names without extension
                            else if (file.name.matches(Regex("^[A-Z][A-Za-z]*$")) ||
                                     file.name.contains("Realm", ignoreCase = true) ||
                                     file.name == "AB" ||
                                     file.name == "SchoolRealmConfiguration") {
                                val lockFile = File(file.parent, "${file.name}.lock")
                                if (lockFile.exists() || file.length() > 1000) {
                                    realmFiles.add(file.absolutePath)
                                    Log.d(TAG, "Found Realm file in parent (no extension): ${file.absolutePath}")
                                }
                            }
                        }
                    }
                }
            }

        } catch (e: Exception) {
            Log.e(TAG, "Error finding Realm files: ${e.message}", e)
        }

        return realmFiles
    }

    /**
     * Diagnostic function to inspect Realm files and report what they contain
     * This helps identify what data is in which file before attempting migration
     *
     * Returns a JSON object with information about each Realm file:
     * {
     *   "file1": {
     *     "path": "...",
     *     "canOpen": true/false,
     *     "isEncrypted": true/false,
     *     "schemas": {
     *       "Quiz": { "count": 123, "fields": [...] },
     *       "Sheet": { "count": 88, "fields": [...] },
     *       ...
     *     }
     *   },
     *   ...
     * }
     */
    fun inspectRealmFiles(): String {
        val realmFiles = findRealmFiles()
        val result = JSONObject()

        for (realmFilePath in realmFiles) {
            val fileInfo = JSONObject()
            val realmFile = File(realmFilePath)

            fileInfo.put("path", realmFilePath)
            fileInfo.put("name", realmFile.name)
            fileInfo.put("size", realmFile.length())
            fileInfo.put("exists", realmFile.exists())

            var realm: DynamicRealm? = null
            try {
                // Check if file is encrypted
                val isEncrypted = isEncryptedRealmFile(realmFilePath)
                fileInfo.put("isEncrypted", isEncrypted)

                // Try to open the Realm file
                Realm.init(context)

                // Copy file to writable location if needed
                val (actualRealmFile, configBuilder) = prepareRealmFileForMigration(realmFile.absolutePath)

                // Add encryption key if file is encrypted
                if (isEncrypted) {
                    val encryptionKey = getEncryptionKey()
                    configBuilder.encryptionKey(encryptionKey)
                }

                val config = configBuilder.build()
                realm = DynamicRealm.getInstance(config)

                fileInfo.put("canOpen", true)

                // Get all schemas
                val schema = realm.schema
                val schemasInfo = JSONObject()

                val allSchemas = schema.all
                Log.d(TAG, "📊 Inspecting file: ${realmFile.name}")
                Log.d(TAG, "   Found ${allSchemas.size} schemas")

                for (realmObjectSchema in allSchemas) {
                    val schemaName = realmObjectSchema.className
                    val schemaInfo = JSONObject()

                    // Get field names
                    val fieldNames = realmObjectSchema.fieldNames
                    val fieldsArray = JSONArray()
                    for (fieldName in fieldNames) {
                        val fieldInfo = JSONObject()
                        val fieldType = realmObjectSchema.getFieldType(fieldName)
                        fieldInfo.put("name", fieldName)
                        fieldInfo.put("type", fieldType.name)
                        fieldInfo.put("isRequired", realmObjectSchema.isRequired(fieldName))
                        fieldInfo.put("isNullable", realmObjectSchema.isNullable(fieldName))
                        fieldsArray.put(fieldInfo)
                    }
                    schemaInfo.put("fields", fieldsArray)

                    // Try to count objects (safely)
                    try {
                        val count = realm.where(schemaName).count()
                        schemaInfo.put("count", count)
                        Log.d(TAG, "   Schema '$schemaName': $count objects")
                    } catch (e: Exception) {
                        schemaInfo.put("count", -1) // -1 means couldn't count
                        schemaInfo.put("countError", e.message ?: "Unknown error")
                        Log.w(TAG, "   Schema '$schemaName': Could not count objects - ${e.message}")
                    }

                    schemasInfo.put(schemaName, schemaInfo)
                }

                fileInfo.put("schemas", schemasInfo)
                fileInfo.put("schemaCount", allSchemas.size)

            } catch (e: Exception) {
                fileInfo.put("canOpen", false)
                fileInfo.put("error", e.message ?: "Unknown error")
                fileInfo.put("errorType", e.javaClass.simpleName)
                Log.e(TAG, "❌ Cannot open Realm file ${realmFile.name}: ${e.message}")
            } finally {
                realm?.close()
            }

            result.put(realmFile.name, fileInfo)
        }

        return result.toString()
    }

  /**
   * Helper function to copy Realm file to writable location if needed
   * Returns the actual file path and configuration builder
   */
  private fun prepareRealmFileForMigration(realmFilePath: String): Pair<File, RealmConfiguration.Builder> {
    val realmFile = File(realmFilePath)
    val filesDir = context.filesDir

    val actualRealmFile: File
    val configBuilder: RealmConfiguration.Builder

    if (realmFile.parent == filesDir.absolutePath) {
      // File is in app's files directory, use default directory
      Log.d(TAG, "Using default files directory for Realm: ${realmFile.name}")
      actualRealmFile = realmFile
      configBuilder = RealmConfiguration.Builder()
        .name(realmFile.name)
    } else {
      // File is in a different location (e.g., parent directory from old app), copy to writable directory first
      Log.d(TAG, "Realm file is in external location, copying to writable directory: ${realmFile.absolutePath}")
      val copiedRealmFile = File(filesDir, realmFile.name)

      try {
        // Copy the file to app's files directory
        realmFile.inputStream().use { input ->
          copiedRealmFile.outputStream().use { output ->
            input.copyTo(output)
          }
        }
        Log.d(TAG, "✅ Successfully copied Realm file to: ${copiedRealmFile.absolutePath}")
        actualRealmFile = copiedRealmFile
      } catch (e: Exception) {
        Log.e(TAG, "❌ Failed to copy Realm file: ${e.message}", e)
        throw e
      }

      // Use default directory (filesDir) since we copied the file there
      configBuilder = RealmConfiguration.Builder()
        .name(copiedRealmFile.name)
    }

    return Pair(actualRealmFile, configBuilder)
  }

  /**
   * Migrate Quiz data from Realm
   *
   * This method tries to find Quiz objects using common Realm model names:
   * - Quiz (most common)
   * - quiz (lowercase)
   * - QuizEntity
   *
   * If you have access to the old app's source code, check:
   * - app/src/main/java/com/bokapp/quizpatente/models/Quiz.java (or .kt)
   * - Look for classes extending RealmObject or annotated with @RealmClass
   *
   * Alternatively, use Realm Studio to inspect the Realm file and see the schema:
   * 1. Open the .realm file in Realm Studio
   * 2. Check the schema tab to see all model names
   */
  fun migrateQuizzes(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val quizzesJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        Log.w(TAG, "Realm file does not exist: $realmFilePath")
        return quizzesJson.toString()
      }

      // Check and fix file permissions if needed
      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false) // Make readable for all
          realmFile.setWritable(true, false) // Make writable for all
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      // Initialize Realm before creating configuration
      Realm.init(context)

      // Check if file is encrypted
      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      // Copy file to writable location if needed
      val (actualRealmFile, configBuilder) = prepareRealmFileForMigration(realmFilePath)

      // Add encryption key if file is encrypted
      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
        Log.d(TAG, "Using encryption key for encrypted Realm file: ${actualRealmFile.name}")
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      // Log all available schemas for debugging
      val schema = realm.schema
      val allSchemas = schema.all.map { it.className }
      Log.d(TAG, "Available Realm schemas in ${actualRealmFile.name}: ${allSchemas.joinToString(", ")}")

      // Try to query Quiz objects using dynamic queries
      // Realm allows querying by class name as string
      try {
        // Method 1: Try using where() with dynamic class name
        // Note: This requires the actual Realm model class to be available
        // If you have the old app's models, uncomment and use:
        /*
        val quizzes = realm.where("Quiz").findAll()
        for (quiz in quizzes) {
          val quizObj = JSONObject()
          quizObj.put("id", quiz.getInt("id"))
          quizObj.put("appId", quiz.getInt("appId"))
          quizObj.put("comment", quiz.getString("comment"))
          quizObj.put("questionText", quiz.getString("questionText"))
          quizObj.put("argumentId", quiz.getInt("argumentId"))
          quizObj.put("licenseTypeId", quiz.getInt("licenseTypeId"))
          quizObj.put("manualId", quiz.getInt("manualId"))
          quizObj.put("image", quiz.getString("image"))
          quizObj.put("position", quiz.getInt("position"))
          quizObj.put("numberExtracted", quiz.getInt("numberExtracted"))
          quizObj.put("result", quiz.getBoolean("result"))
          quizObj.put("symbol", quiz.getString("symbol"))
          quizObj.put("originalId", quiz.getString("originalId"))
          quizObj.put("hasAnswer", quiz.getBoolean("hasAnswer"))

          // Handle dates
          val createdDate = quiz.getDate("createdDatetime")
          if (createdDate != null) {
            quizObj.put("createdDatetime", createdDate.toString())
          }
          val modifiedDate = quiz.getDate("modifiedDatetime")
          if (modifiedDate != null) {
            quizObj.put("modifiedDatetime", modifiedDate.toString())
          }

          quizzesJson.put(quizObj)
        }
        */

        // Method 2: Use Realm's schema introspection to find the model
        // This doesn't require the model classes
        // Schema is already obtained above for logging
        val quizSchema = schema.get("Quiz") ?: schema.get("quiz") ?: schema.get("QuizEntity")

        if (quizSchema != null) {
          Log.d(TAG, "Found Quiz schema: ${quizSchema.className}")
          val quizzes = realm.where(quizSchema.className).findAll()

          for (quiz in quizzes) {
            try {
              val quizObj = JSONObject()
              val dynQuiz = quiz as DynamicRealmObject

              // Map Realm fields to Flutter model fields based on REALM_SCHEMA.md
              quizObj.put("id", dynQuiz.getLong("id"))

              // originalId -> original_id
              val originalId = dynQuiz.getString("originalId")
              if (originalId != null) quizObj.put("originalId", originalId)

              // text -> questionText
              val text = dynQuiz.getString("text")
              if (text != null) quizObj.put("questionText", text)

              // image is a Picture relationship - extract URL
              try {
                val imageObj = dynQuiz.getObject("image")
                if (imageObj != null) {
                  val dynImageObj = imageObj as DynamicRealmObject
                  val imageUrl = dynImageObj.getString("url")
                  if (imageUrl != null) quizObj.put("image", imageUrl)
                }
              } catch (e: Exception) {
                // Image might be null or not a relationship
              }

              // result -> result
              quizObj.put("result", dynQuiz.getBoolean("result"))

              // requestedAnswer -> hasAnswer
              quizObj.put("hasAnswer", dynQuiz.getBoolean("requestedAnswer"))

              // position -> position
              val position = dynQuiz.getLong("position")
              quizObj.put("position", position.toInt())

              // isActive -> isActive (not used in Flutter but good to have)
              quizObj.put("isActive", dynQuiz.getBoolean("isActive"))

              // symbol -> symbol
              val symbol = dynQuiz.getString("symbol")
              if (symbol != null) quizObj.put("symbol", symbol)

              // comment -> comment
              val comment = dynQuiz.getString("comment")
              if (comment != null) quizObj.put("comment", comment)

              // manual -> manualId
              val manual = dynQuiz.getLong("manual")
              if (manual != 0L) quizObj.put("manualId", manual.toInt())

              // licenseType -> licenseTypeId
              val licenseType = dynQuiz.getLong("licenseType")
              quizObj.put("licenseTypeId", licenseType.toInt())

              // topic (argument) -> argumentId
              val topic = dynQuiz.getLong("topic")
              quizObj.put("argumentId", topic.toInt())

              // createdDate -> createdDatetime (as timestamp in milliseconds)
              val createdDate = dynQuiz.getDate("createdDate")
              if (createdDate != null) {
                quizObj.put("createdDatetime", createdDate.time)
              }

              // lastUpdate -> modifiedDatetime (as timestamp in milliseconds)
              val lastUpdate = dynQuiz.getDate("lastUpdate")
              if (lastUpdate != null) {
                quizObj.put("modifiedDatetime", lastUpdate.time)
              }

              // numberExtraction -> numberExtracted
              val numberExtraction = dynQuiz.getLong("numberExtraction")
              quizObj.put("numberExtracted", numberExtraction.toInt())

              // appId - not in Realm schema, set to 0
              quizObj.put("appId", 0)

              // updateDbId - not in Realm schema, set to null
              quizObj.put("updateDbId", JSONObject.NULL)

              quizzesJson.put(quizObj)
            } catch (e: Exception) {
              Log.e(TAG, "Error processing quiz: ${e.message}", e)
            }
          }
        } else {
          Log.w(TAG, "Quiz schema not found. Available schemas: ${schema.all.map { it.className }}")
        }
      } catch (e: Exception) {
        Log.e(TAG, "Error querying Quiz objects: ${e.message}", e)
      }

      Log.d(TAG, "Migrated ${quizzesJson.length()} quizzes from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        Log.e(TAG, "   Error: ${e.message}")
        Log.e(TAG, "   This file requires an encryption key to open.")
        // Re-throw to signal Dart code to try next file
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating quizzes from Realm: ${e.message}", e)
        // Re-throw other errors too so Dart can try next file
        throw e
      }
    } finally {
      realm?.close()
    }

    return quizzesJson.toString()
  }

  /**
   * Helper function to safely get Long value from DynamicRealmObject
   * Returns default value if field is null or doesn't exist
   */
  private fun safeGetLong(obj: DynamicRealmObject, fieldName: String, defaultValue: Long = 0L): Long {
    return try {
      // Check if field exists first to avoid native crashes
      if (!obj.hasField(fieldName)) {
        return defaultValue
      }
      // Check if field is null
      if (obj.isNull(fieldName)) {
        return defaultValue
      }
      obj.getLong(fieldName)
    } catch (e: Exception) {
      // Field might not exist, be null, or be inaccessible - return default silently
      // Don't log warnings for expected failures (missing fields)
      defaultValue
    }
  }

  /**
   * Helper function to safely get String value from DynamicRealmObject
   * Returns null if field is null or doesn't exist
   */
  private fun safeGetString(obj: DynamicRealmObject, fieldName: String): String? {
    return try {
      // Check if field exists first to avoid native crashes
      if (!obj.hasField(fieldName)) {
        return null
      }
      // Check if field is null
      if (obj.isNull(fieldName)) {
        return null
      }
      obj.getString(fieldName)
    } catch (e: Exception) {
      // Field might not exist, be null, or be inaccessible - return null silently
      null
    }
  }

  /**
   * Helper function to safely get Date value from DynamicRealmObject
   * Returns null if field is null or doesn't exist
   */
  private fun safeGetDate(obj: DynamicRealmObject, fieldName: String): java.util.Date? {
    return try {
      // Check if field exists first to avoid native crashes
      if (!obj.hasField(fieldName)) {
        return null
      }
      // Check if field is null
      if (obj.isNull(fieldName)) {
        return null
      }
      obj.getDate(fieldName)
    } catch (e: Exception) {
      // Field might not exist, be null, or be inaccessible - return null silently
      null
    }
  }

  /**
   * Helper function to safely get Boolean value from DynamicRealmObject
   * Returns default value if field is null or doesn't exist
   */
  private fun safeGetBoolean(obj: DynamicRealmObject, fieldName: String, defaultValue: Boolean = false): Boolean {
    return try {
      // Check if field exists first to avoid native crashes
      if (!obj.hasField(fieldName)) {
        return defaultValue
      }
      // Check if field is null
      if (obj.isNull(fieldName)) {
        return defaultValue
      }
      obj.getBoolean(fieldName)
    } catch (e: Exception) {
      // Field might not exist, be null, or be inaccessible - return default silently
      defaultValue
    }
  }

  /**
   * Helper function to safely get RealmList from DynamicRealmObject
   * Returns null if field is null or doesn't exist
   */
  private fun safeGetList(obj: DynamicRealmObject, fieldName: String): io.realm.RealmList<*>? {
    return try {
      // Check if field exists first to avoid native crashes
      if (!obj.hasField(fieldName)) {
        return null
      }
      // Check if field is null
      if (obj.isNull(fieldName)) {
        return null
      }
      obj.getList(fieldName)
    } catch (e: Exception) {
      // Field might not exist, be null, or be inaccessible - return null silently
      null
    }
  }

  /**
   * Migrate Sheets data from Realm
   *
   * Tries common model names: Sheet, sheet, SheetEntity
   */
  fun migrateSheets(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val sheetsJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return sheetsJson.toString()
      }

      // Check and fix file permissions if needed
      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      // Initialize Realm before creating configuration
      Realm.init(context)

      // Check if file is encrypted
      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      // Copy file to writable location if needed
      val (actualRealmFile, configBuilder) = prepareRealmFileForMigration(realmFilePath)

      // Add encryption key if file is encrypted
      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
        Log.d(TAG, "Using encryption key for encrypted Realm file: ${actualRealmFile.name}")
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val sheetSchema = schema.get("Sheet") ?: schema.get("sheet") ?: schema.get("SheetEntity")

      if (sheetSchema != null) {
        Log.d(TAG, "Found Sheet schema: ${sheetSchema.className}")
        try {
          val sheets = realm.where(sheetSchema.className).findAll()

          for (sheet in sheets) {
            try {
            val sheetObj = JSONObject()
            val dynSheet = sheet as DynamicRealmObject

            // Map Realm fields to Flutter model fields based on REALM_SCHEMA.md
            // Use safe helper functions to handle nullable/optional fields
            sheetObj.put("id", safeGetLong(dynSheet, "id"))

            // teacher -> teacher
            val teacher = safeGetLong(dynSheet, "teacher")
            if (teacher != 0L) sheetObj.put("teacher", teacher.toInt())

            // student -> student
            val student = safeGetLong(dynSheet, "student")
            if (student != 0L) sheetObj.put("student", student.toInt())

            // licenseType -> licenseTypeId
            val licenseType = safeGetLong(dynSheet, "licenseType")
            sheetObj.put("licenseTypeId", licenseType.toInt())

            // createdDate -> createdDatetime (as timestamp in milliseconds)
            val createdDate = safeGetDate(dynSheet, "createdDate")
            if (createdDate != null) {
              sheetObj.put("createdDatetime", createdDate.time)
            }

            // expirationDate -> expirationDatetime (as timestamp in milliseconds)
            val expirationDate = safeGetDate(dynSheet, "expirationDate")
            if (expirationDate != null) {
              sheetObj.put("expirationDatetime", expirationDate.time)
            }

            // lastUpdate -> modifiedDatetime (as timestamp in milliseconds)
            val lastUpdate = safeGetDate(dynSheet, "lastUpdate")
            if (lastUpdate != null) {
              sheetObj.put("modifiedDatetime", lastUpdate.time)
            }

            // type -> type
            val type = safeGetLong(dynSheet, "type")
            sheetObj.put("type", type.toInt())

            // duration -> duration (String in Realm, need to parse to Double)
            val durationStr = safeGetString(dynSheet, "duration")
            if (durationStr != null && durationStr.isNotEmpty()) {
              try {
                sheetObj.put("duration", durationStr.toDouble())
              } catch (e: Exception) {
                sheetObj.put("duration", 0.0)
              }
            } else {
              sheetObj.put("duration", 0.0)
            }

            // numberQuestion -> numberQuestion
            val numberQuestion = safeGetLong(dynSheet, "numberQuestion")
            sheetObj.put("numberQuestion", numberQuestion.toInt())

            // maxNumberError -> maxNumberError
            val maxNumberError = safeGetLong(dynSheet, "maxNumberError")
            sheetObj.put("maxNumberError", maxNumberError.toInt())

            // startDate -> startDatetime (as timestamp in milliseconds)
            val startDate = safeGetDate(dynSheet, "startDate")
            if (startDate != null) {
              sheetObj.put("startDatetime", startDate.time)
            }

            // endDate -> endDatetime (as timestamp in milliseconds)
            val endDate = safeGetDate(dynSheet, "endDate")
            if (endDate != null) {
              sheetObj.put("endDatetime", endDate.time)
            }

            // numberCorrectQuestion -> numberCorrectQuestion
            val numberCorrectQuestion = safeGetLong(dynSheet, "numberCorrectQuestion")
            sheetObj.put("numberCorrectQuestion", numberCorrectQuestion.toInt())

            // numberErrorQuestion -> numberErrorQuestion
            val numberErrorQuestion = safeGetLong(dynSheet, "numberErrorQuestion")
            sheetObj.put("numberErrorQuestion", numberErrorQuestion.toInt())

            // executionTime -> executionTime
            val executionTime = safeGetLong(dynSheet, "executionTime")
            sheetObj.put("executionTime", executionTime.toInt())

            // numberEmptyQuestion -> numberEmptyQuestion
            val numberEmptyQuestion = safeGetLong(dynSheet, "numberEmptyQuestion")
            sheetObj.put("numberEmptyQuestion", numberEmptyQuestion.toInt())

            // quizzes -> quizzes (String, already serialized)
            val quizzes = safeGetString(dynSheet, "quizzes")
            if (quizzes != null) {
              sheetObj.put("quizzes", quizzes)
            } else {
              // If quizzes is null, try to serialize listItemQuizzes
              try {
                val itemQuizzesList = safeGetList(dynSheet, "listItemQuizzes")
                if (itemQuizzesList != null && itemQuizzesList.size > 0) {
                  val quizzesArray = org.json.JSONArray()
                  for (item in itemQuizzesList) {
                    try {
                      val itemObj = org.json.JSONObject()
                      // ItemQuizzes objects are already DynamicRealmObjects from RealmList
                      // Access fields directly without using safe helpers to avoid Realm SDK warnings
                      if (item is DynamicRealmObject) {
                        try {
                          val idQuiz = item.getLong("idQuiz")
                          itemObj.put("idQuiz", idQuiz)
                        } catch (e: Exception) {
                          // Field might not exist or be null
                          itemObj.put("idQuiz", 0L)
                        }
                        try {
                          val quizAnswer = item.getLong("quizAnswer")
                          itemObj.put("quizAnswer", quizAnswer)
                        } catch (e: Exception) {
                          // Field might not exist or be null
                          itemObj.put("quizAnswer", 0L)
                        }
                        quizzesArray.put(itemObj)
                      }
                    } catch (e: Exception) {
                      // Skip items that can't be serialized
                      Log.w(TAG, "Error serializing quiz item: ${e.message}")
                    }
                  }
                  sheetObj.put("quizzes", quizzesArray.toString())
                } else {
                  sheetObj.put("quizzes", "[]")
                }
              } catch (e: Exception) {
                sheetObj.put("quizzes", "[]")
              }
            }

            // executed -> isExecuted
            sheetObj.put("isExecuted", safeGetBoolean(dynSheet, "executed"))

            // passed -> isPassed
            sheetObj.put("isPassed", safeGetBoolean(dynSheet, "passed"))

            // hasAnswer -> hasAnswer
            sheetObj.put("hasAnswer", safeGetBoolean(dynSheet, "hasAnswer"))

            // groupCode - not in Realm schema, set to null (optional field)
            // hasIncrementedCount - not in Realm schema, set to false (has default value)

            // os, version, isOffline - in Realm but not used in Flutter, ignore

            // Log student and teacher IDs to help identify the guest user
            val studentId = safeGetLong(dynSheet, "student")
            val teacherId = safeGetLong(dynSheet, "teacher")
            Log.d(TAG, "Sheet ${sheetObj.get("id")}: student=$studentId, teacher=$teacherId")

            sheetsJson.put(sheetObj)
          } catch (e: Exception) {
            Log.e(TAG, "Error processing sheet: ${e.message}", e)
            // Continue to next sheet - don't crash the entire migration
          }
        }
        } catch (e: Exception) {
          // Catch fatal exceptions from Realm native code when iterating or accessing fields
          Log.e(TAG, "❌ Fatal error accessing sheets from Realm file: ${e.message}")
          Log.e(TAG, "   This might be due to schema mismatch or corrupted data. Returning empty result.")
          // Return empty array instead of crashing
          return JSONArray().toString()
        }
      } else {
        Log.w(TAG, "Sheet schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${sheetsJson.length()} sheets from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        Log.e(TAG, "   Error: ${e.message}")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating sheets from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return sheetsJson.toString()
  }

  /**
   * Migrate Quiz Answers data from Realm
   *
   * Tries common model names: QuizAnswer, QuizAnswers, quizAnswer, quiz_answer
   */
  fun migrateQuizAnswers(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val answersJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return answersJson.toString()
      }

      // Check and fix file permissions if needed
      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      // Initialize Realm before creating configuration
      Realm.init(context)

      // Check if file is encrypted
      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      // Copy file to writable location if needed
      val (actualRealmFile, configBuilder) = prepareRealmFileForMigration(realmFilePath)

      // Add encryption key if file is encrypted
      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
        Log.d(TAG, "Using encryption key for encrypted Realm file: ${actualRealmFile.name}")
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val answerSchema = schema.get("QuizAnswer")
        ?: schema.get("QuizAnswers")
        ?: schema.get("quizAnswer")
        ?: schema.get("quiz_answer")
        ?: schema.get("QuizAnswerEntity")

      if (answerSchema != null) {
        Log.d(TAG, "Found QuizAnswer schema: ${answerSchema.className}")
        val answers = realm.where(answerSchema.className).findAll()

        for (answer in answers) {
          try {
            val answerObj = JSONObject()
            val dynAnswer = answer as DynamicRealmObject

            // Map Realm fields to Flutter model fields based on REALM_SCHEMA.md
            answerObj.put("id", dynAnswer.getLong("id"))

            // text -> answerText
            val text = dynAnswer.getString("text")
            if (text != null) answerObj.put("answerText", text)

            // position -> position
            val position = dynAnswer.getLong("position")
            answerObj.put("position", position.toInt())

            // createdDate -> createdDatetime (as timestamp in milliseconds)
            val createdDate = dynAnswer.getDate("createdDate")
            if (createdDate != null) {
              answerObj.put("createdDatetime", createdDate.time)
            }

            // lastUpdate -> modifiedDatetime (as timestamp in milliseconds)
            val lastUpdate = dynAnswer.getDate("lastUpdate")
            if (lastUpdate != null) {
              answerObj.put("modifiedDatetime", lastUpdate.time)
            }

            // isCorrect -> isCorrect
            answerObj.put("isCorrect", dynAnswer.getBoolean("isCorrect"))

            // isActive -> isActive (not used in Flutter but good to have)
            answerObj.put("isActive", dynAnswer.getBoolean("isActive"))

            // licenseType -> licenseTypeId
            val licenseType = dynAnswer.getLong("licenseType")
            answerObj.put("licenseTypeId", licenseType.toInt())

            // quiz -> quizId
            val quiz = dynAnswer.getLong("quiz")
            answerObj.put("quizId", quiz.toInt())

            // updateDbId - not in Realm schema, set to null
            answerObj.put("updateDbId", JSONObject.NULL)

            answersJson.put(answerObj)
          } catch (e: Exception) {
            Log.e(TAG, "Error processing quiz answer: ${e.message}", e)
          }
        }
      } else {
        Log.w(TAG, "QuizAnswer schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${answersJson.length()} quiz answers from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        Log.e(TAG, "   Error: ${e.message}")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating quiz answers from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return answersJson.toString()
  }

  /**
   * Migrate Manual Books data from Realm
   *
   * Tries common model names: ManualBook, ManualBooks, manualBook, manual_book
   */
  fun migrateManualBooks(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val manualBooksJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return manualBooksJson.toString()
      }

      // Check and fix file permissions if needed
      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      // Initialize Realm before creating configuration
      Realm.init(context)

      // Check if file is encrypted
      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      // Copy file to writable location if needed
      val (actualRealmFile, configBuilder) = prepareRealmFileForMigration(realmFilePath)

      // Add encryption key if file is encrypted
      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
        Log.d(TAG, "Using encryption key for encrypted Realm file: ${actualRealmFile.name}")
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val manualBookSchema = schema.get("ManualBook")
        ?: schema.get("ManualBooks")
        ?: schema.get("manualBook")
        ?: schema.get("manual_book")
        ?: schema.get("ManualBookEntity")

      if (manualBookSchema != null) {
        Log.d(TAG, "Found ManualBook schema: ${manualBookSchema.className}")
        val manualBooks = realm.where(manualBookSchema.className).findAll()

        for (manualBook in manualBooks) {
          try {
            val manualBookObj = JSONObject()
            val dynManualBook = manualBook as DynamicRealmObject

            // Map Realm fields to Flutter model fields based on REALM_SCHEMA.md
            manualBookObj.put("id", dynManualBook.getLong("id"))

            // manualSerializer -> manuals (String containing serialized array)
            val manualSerializer = dynManualBook.getString("manualSerializer")
            if (manualSerializer != null) {
              manualBookObj.put("manuals", manualSerializer)
            } else {
              manualBookObj.put("manuals", "[]")
            }

            // createdDate -> createdDatetime (as timestamp in milliseconds)
            val createdDate = dynManualBook.getDate("createdDate")
            if (createdDate != null) {
              manualBookObj.put("createdDatetime", createdDate.time)
            }

            // lastUpdate -> modifiedDatetime (as timestamp in milliseconds)
            val lastUpdate = dynManualBook.getDate("lastUpdate")
            if (lastUpdate != null) {
              manualBookObj.put("modifiedDatetime", lastUpdate.time)
            }

            // topic (argument) -> argument
            val topic = dynManualBook.getLong("topic")
            if (topic != 0L) {
              manualBookObj.put("argument", topic.toInt())
            }

            // isScan -> hasBeenScanned
            manualBookObj.put("hasBeenScanned", dynManualBook.getBoolean("isScan"))

            // updateDbId - not in Realm schema, set to null
            manualBookObj.put("updateDbId", JSONObject.NULL)

            manualBooksJson.put(manualBookObj)
          } catch (e: Exception) {
            Log.e(TAG, "Error processing manual book: ${e.message}", e)
          }
        }
      } else {
        Log.w(TAG, "ManualBook schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${manualBooksJson.length()} manual books from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        Log.e(TAG, "   Error: ${e.message}")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating manual books from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return manualBooksJson.toString()
  }

  /**
   * Migrate User data from Realm database
   *
   * Tries common model names: User, user, UserEntity
   */
  fun migrateUsers(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val usersJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return usersJson.toString()
      }

      // Check and fix file permissions if needed
      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      // Initialize Realm before creating configuration
      Realm.init(context)

      // Check if file is encrypted
      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      // Copy file to writable location if needed
      val (actualRealmFile, configBuilder) = prepareRealmFileForMigration(realmFilePath)

      // Add encryption key if file is encrypted
      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
        Log.d(TAG, "Using encryption key for encrypted Realm file: ${actualRealmFile.name}")
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val userSchema = schema.get("User")
        ?: schema.get("user")
        ?: schema.get("UserEntity")

      if (userSchema != null) {
        Log.d(TAG, "Found User schema: ${userSchema.className}")
        val users = realm.where(userSchema.className).findAll()

        Log.d(TAG, "Found ${users.size} User objects in Realm")

        for (user in users) {
          try {
            val userObj = JSONObject()
            val dynUser = user as DynamicRealmObject

            // Map Realm fields to Flutter model fields based on REALM_SCHEMA.md
            userObj.put("id", safeGetLong(dynUser, "id"))

            // email -> email
            val email = safeGetString(dynUser, "email")
            if (email != null) userObj.put("email", email)

            // name -> name (firstname)
            val name = safeGetString(dynUser, "name")
            if (name != null) userObj.put("name", name)

            // surname -> surname
            val surname = safeGetString(dynUser, "surname")
            if (surname != null) userObj.put("surname", surname)

            // udid -> udid
            val udid = safeGetString(dynUser, "udid")
            if (udid != null) userObj.put("udid", udid)

            // isGuest -> isGuest
            userObj.put("isGuest", safeGetBoolean(dynUser, "isGuest"))

            // lastLogin -> lastLogin (as timestamp in milliseconds)
            val lastLogin = safeGetDate(dynUser, "lastLogin")
            if (lastLogin != null) {
              userObj.put("lastLogin", lastLogin.time)
            }

            // registrationDate -> registrationDate (as timestamp in milliseconds)
            val registrationDate = safeGetDate(dynUser, "registrationDate")
            if (registrationDate != null) {
              userObj.put("registrationDate", registrationDate.time)
            }

            // birthdate -> birthdate (as timestamp in milliseconds)
            val birthdate = safeGetDate(dynUser, "birthdate")
            if (birthdate != null) {
              userObj.put("birthdate", birthdate.time)
            }

            // phone -> phone
            val phone = safeGetString(dynUser, "phone")
            if (phone != null) userObj.put("phone", phone)

            // address -> address
            val address = safeGetString(dynUser, "address")
            if (address != null) userObj.put("address", address)

            // city -> city
            val city = safeGetString(dynUser, "city")
            if (city != null) userObj.put("city", city)

            // zipCode -> zipCode
            val zipCode = safeGetString(dynUser, "zipCode")
            if (zipCode != null) userObj.put("zipCode", zipCode)

            // province -> province
            val province = safeGetString(dynUser, "province")
            if (province != null) userObj.put("province", province)

            // country -> country
            val country = safeGetString(dynUser, "country")
            if (country != null) userObj.put("country", country)

            // latitude -> latitude
            val latitude = safeGetString(dynUser, "latitude")
            if (latitude != null) {
              try {
                userObj.put("latitude", latitude.toDouble())
              } catch (e: Exception) {
                // Ignore if not a valid double
              }
            }

            // longiture (typo in schema) -> longitude
            val longitude = safeGetString(dynUser, "longiture")
            if (longitude != null) {
              try {
                userObj.put("longitude", longitude.toDouble())
              } catch (e: Exception) {
                // Ignore if not a valid double
              }
            }

            // image -> image
            val image = safeGetString(dynUser, "image")
            if (image != null) userObj.put("image", image)

            // isPlayingCard -> isPlayingCard
            userObj.put("isPlayingCard", safeGetBoolean(dynUser, "isPlayingCard"))

            // isWinnerCard -> isWinnerCard
            userObj.put("isWinnerCard", safeGetBoolean(dynUser, "isWinnerCard"))

            // isParticipatingContest -> isParticipatingContest
            userObj.put("isParticipatingContest", safeGetBoolean(dynUser, "isParticipatingContest"))

            usersJson.put(userObj)

            Log.d(TAG, "Migrated User: id=${userObj.get("id")}, email=$email, isGuest=${userObj.get("isGuest")}")
          } catch (e: Exception) {
            Log.e(TAG, "Error processing user: ${e.message}", e)
          }
        }
      } else {
        Log.w(TAG, "User schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${usersJson.length()} users from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        Log.e(TAG, "   Error: ${e.message}")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating users from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return usersJson.toString()
  }

  /**
   * Migrate ItemQuizzes data from Realm database
   * This is CRITICAL - represents completed quiz items (90 objects found!)
   *
   * Tries common model names: ItemQuizzes, ItemQuiz, itemQuizzes, item_quizzes
   */
  fun migrateItemQuizzes(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val itemQuizzesJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return itemQuizzesJson.toString()
      }

      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      Realm.init(context)

      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      // Copy file to writable location if needed
      val (actualRealmFile, configBuilder) = prepareRealmFileForMigration(realmFilePath)

      // Add encryption key if file is encrypted
      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
        Log.d(TAG, "Using encryption key for encrypted Realm file: ${actualRealmFile.name}")
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val itemQuizzesSchema = schema.get("ItemQuizzes")
        ?: schema.get("ItemQuiz")
        ?: schema.get("itemQuizzes")
        ?: schema.get("item_quizzes")

      if (itemQuizzesSchema != null) {
        Log.d(TAG, "Found ItemQuizzes schema: ${itemQuizzesSchema.className}")
        val itemQuizzes = realm.where(itemQuizzesSchema.className).findAll()

        Log.d(TAG, "Found ${itemQuizzes.size} ItemQuizzes objects in Realm")

        for (itemQuiz in itemQuizzes) {
          try {
            val itemQuizObj = JSONObject()
            val dynItemQuiz = itemQuiz as DynamicRealmObject

            // Map Realm fields to Flutter model fields based on REALM_SCHEMA.md
            // id is a String composite key (idSheet_licenseType_idQuiz)
            val id = safeGetString(dynItemQuiz, "id")
            if (id != null) itemQuizObj.put("id", id)

            // date -> date (as timestamp in milliseconds)
            val date = safeGetDate(dynItemQuiz, "date")
            if (date != null) {
              itemQuizObj.put("date", date.time)
            }

            // idSheet -> idSheet
            val idSheet = safeGetLong(dynItemQuiz, "idSheet")
            itemQuizObj.put("idSheet", idSheet.toInt())

            // licenseType -> licenseType
            val licenseType = safeGetLong(dynItemQuiz, "licenseType")
            itemQuizObj.put("licenseType", licenseType.toInt())

            // idQuiz -> idQuiz
            val idQuiz = safeGetLong(dynItemQuiz, "idQuiz")
            itemQuizObj.put("idQuiz", idQuiz.toInt())

            // quizAnswer -> quizAnswer
            val quizAnswer = safeGetLong(dynItemQuiz, "quizAnswer")
            itemQuizObj.put("quizAnswer", quizAnswer.toInt())

            // correct -> correct
            val correct = safeGetLong(dynItemQuiz, "correct")
            itemQuizObj.put("correct", correct.toInt())

            // idTopic -> idTopic
            val idTopic = safeGetLong(dynItemQuiz, "idTopic")
            itemQuizObj.put("idTopic", idTopic.toInt())

            // isExecuted -> isExecuted
            itemQuizObj.put("isExecuted", safeGetBoolean(dynItemQuiz, "isExecuted"))

            itemQuizzesJson.put(itemQuizObj)
          } catch (e: Exception) {
            Log.e(TAG, "Error processing ItemQuiz: ${e.message}", e)
          }
        }
      } else {
        Log.w(TAG, "ItemQuizzes schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${itemQuizzesJson.length()} ItemQuizzes from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        Log.e(TAG, "   Error: ${e.message}")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating ItemQuizzes from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return itemQuizzesJson.toString()
  }

  /**
   * Migrate LicenseType data from Realm database
   */
  fun migrateLicenseTypes(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val licenseTypesJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return licenseTypesJson.toString()
      }

      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      Realm.init(context)

      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      val filesDir = context.filesDir
      val configBuilder = if (realmFile.parent == filesDir.absolutePath) {
        RealmConfiguration.Builder().name(realmFile.name)
      } else {
        RealmConfiguration.Builder().name(realmFile.name).directory(realmFile.parentFile)
      }

      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val licenseTypeSchema = schema.get("LicenseType")
        ?: schema.get("licenseType")
        ?: schema.get("LicenseTypeEntity")

      if (licenseTypeSchema != null) {
        Log.d(TAG, "Found LicenseType schema: ${licenseTypeSchema.className}")
        val licenseTypes = realm.where(licenseTypeSchema.className).findAll()

        for (licenseType in licenseTypes) {
          try {
            val licenseTypeObj = JSONObject()
            val dynLicenseType = licenseType as DynamicRealmObject

            licenseTypeObj.put("id", safeGetLong(dynLicenseType, "id"))

            val name = safeGetString(dynLicenseType, "name")
            if (name != null) licenseTypeObj.put("name", name)

            val note = safeGetString(dynLicenseType, "note")
            if (note != null) licenseTypeObj.put("note", note)

            val position = safeGetLong(dynLicenseType, "position")
            licenseTypeObj.put("position", position.toInt())

            // thumb -> thumb (Picture relationship - extract URL)
            try {
              val thumbObj = dynLicenseType.getObject("thumb")
              if (thumbObj != null) {
                val dynThumbObj = thumbObj as DynamicRealmObject
                val thumbUrl = safeGetString(dynThumbObj, "url")
                if (thumbUrl != null) licenseTypeObj.put("thumb", thumbUrl)
              }
            } catch (e: Exception) {
              // Thumb might be null or not a relationship
            }

            licenseTypeObj.put("isActive", safeGetBoolean(dynLicenseType, "isActive"))

            val time = safeGetLong(dynLicenseType, "time")
            licenseTypeObj.put("time", time)

            val numberOfQuestions = safeGetLong(dynLicenseType, "numberOfQuestions")
            licenseTypeObj.put("numberOfQuestions", numberOfQuestions.toInt())

            val numberOfAnswer = safeGetLong(dynLicenseType, "numberOfAnswer")
            licenseTypeObj.put("numberOfAnswer", numberOfAnswer.toInt())

            val maxErrors = safeGetLong(dynLicenseType, "maxErrors")
            licenseTypeObj.put("maxErrors", maxErrors.toInt())

            val numberQuizzes = safeGetLong(dynLicenseType, "numberQuizzes")
            licenseTypeObj.put("numberQuizzes", numberQuizzes.toInt())

            val createdDate = safeGetDate(dynLicenseType, "createdDate")
            if (createdDate != null) {
              licenseTypeObj.put("createdDate", createdDate.time)
            }

            val lastUpdate = safeGetDate(dynLicenseType, "lastUpdate")
            if (lastUpdate != null) {
              licenseTypeObj.put("lastUpdate", lastUpdate.time)
            }

            licenseTypeObj.put("isRevision", safeGetBoolean(dynLicenseType, "isRevision"))
            licenseTypeObj.put("hasAnswer", safeGetBoolean(dynLicenseType, "hasAnswer"))

            licenseTypesJson.put(licenseTypeObj)
          } catch (e: Exception) {
            Log.e(TAG, "Error processing LicenseType: ${e.message}", e)
          }
        }
      } else {
        Log.w(TAG, "LicenseType schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${licenseTypesJson.length()} LicenseTypes from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating LicenseTypes from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return licenseTypesJson.toString()
  }

  /**
   * Migrate Manual data from Realm database
   */
  fun migrateManuals(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val manualsJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return manualsJson.toString()
      }

      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      Realm.init(context)

      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      val filesDir = context.filesDir
      val configBuilder = if (realmFile.parent == filesDir.absolutePath) {
        RealmConfiguration.Builder().name(realmFile.name)
      } else {
        RealmConfiguration.Builder().name(realmFile.name).directory(realmFile.parentFile)
      }

      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val manualSchema = schema.get("Manual")
        ?: schema.get("manual")
        ?: schema.get("ManualEntity")

      if (manualSchema != null) {
        Log.d(TAG, "Found Manual schema: ${manualSchema.className}")
        val manuals = realm.where(manualSchema.className).findAll()

        for (manual in manuals) {
          try {
            val manualObj = JSONObject()
            val dynManual = manual as DynamicRealmObject

            manualObj.put("id", safeGetLong(dynManual, "id"))

            // image -> image (Picture relationship - extract URL)
            try {
              val imageObj = dynManual.getObject("image")
              if (imageObj != null) {
                val dynImageObj = imageObj as DynamicRealmObject
                val imageUrl = safeGetString(dynImageObj, "url")
                if (imageUrl != null) manualObj.put("image", imageUrl)
              }
            } catch (e: Exception) {
              // Image might be null or not a relationship
            }

            val appId = safeGetLong(dynManual, "appId")
            manualObj.put("appId", appId.toInt())

            val title = safeGetString(dynManual, "title")
            if (title != null) manualObj.put("title", title)

            val text = safeGetString(dynManual, "text")
            if (text != null) manualObj.put("text", text)

            val symbol = safeGetString(dynManual, "symbol")
            if (symbol != null) manualObj.put("symbol", symbol)

            val note = safeGetString(dynManual, "note")
            if (note != null) manualObj.put("note", note)

            val alt = safeGetString(dynManual, "alt")
            if (alt != null) manualObj.put("alt", alt)

            val url = safeGetString(dynManual, "url")
            if (url != null) manualObj.put("url", url)

            val createdDate = safeGetDate(dynManual, "createdDate")
            if (createdDate != null) {
              manualObj.put("createdDate", createdDate.time)
            }

            val lastUpdate = safeGetDate(dynManual, "lastUpdate")
            if (lastUpdate != null) {
              manualObj.put("lastUpdate", lastUpdate.time)
            }

            val position = safeGetLong(dynManual, "position")
            manualObj.put("position", position.toInt())

            val videoOriginalId = safeGetLong(dynManual, "videoOriginalId")
            manualObj.put("videoOriginalId", videoOriginalId.toInt())

            manualObj.put("isActive", safeGetBoolean(dynManual, "isActive"))

            val licenseType = safeGetLong(dynManual, "licenseType")
            manualObj.put("licenseType", licenseType.toInt())

            val topic = safeGetLong(dynManual, "topic")
            manualObj.put("topic", topic.toInt())

            // video -> video (Video relationship - extract ID)
            try {
              val videoObj = dynManual.getObject("video")
              if (videoObj != null) {
                val dynVideoObj = videoObj as DynamicRealmObject
                val videoId = safeGetLong(dynVideoObj, "id")
                manualObj.put("videoId", videoId.toInt())
              }
            } catch (e: Exception) {
              // Video might be null or not a relationship
            }

            manualsJson.put(manualObj)
          } catch (e: Exception) {
            Log.e(TAG, "Error processing Manual: ${e.message}", e)
          }
        }
      } else {
        Log.w(TAG, "Manual schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${manualsJson.length()} Manuals from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating Manuals from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return manualsJson.toString()
  }

  /**
   * Migrate Topic (Arguments) data from Realm database
   */
  fun migrateTopics(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val topicsJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return topicsJson.toString()
      }

      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      Realm.init(context)

      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      val filesDir = context.filesDir
      val configBuilder = if (realmFile.parent == filesDir.absolutePath) {
        RealmConfiguration.Builder().name(realmFile.name)
      } else {
        RealmConfiguration.Builder().name(realmFile.name).directory(realmFile.parentFile)
      }

      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val topicSchema = schema.get("Topic")
        ?: schema.get("topic")
        ?: schema.get("TopicEntity")

      if (topicSchema != null) {
        Log.d(TAG, "Found Topic schema: ${topicSchema.className}")
        val topics = realm.where(topicSchema.className).findAll()

        for (topic in topics) {
          try {
            val topicObj = JSONObject()
            val dynTopic = topic as DynamicRealmObject

            topicObj.put("id", safeGetLong(dynTopic, "id"))

            val name = safeGetString(dynTopic, "name")
            if (name != null) topicObj.put("name", name)

            val note = safeGetString(dynTopic, "note")
            if (note != null) topicObj.put("note", note)

            val position = safeGetLong(dynTopic, "position")
            topicObj.put("position", position.toInt())

            val licenseType = safeGetLong(dynTopic, "licenseType")
            topicObj.put("licenseType", licenseType.toInt())

            val createdDate = safeGetDate(dynTopic, "createdDate")
            if (createdDate != null) {
              topicObj.put("createdDate", createdDate.time)
            }

            val lastUpdate = safeGetDate(dynTopic, "lastUpdate")
            if (lastUpdate != null) {
              topicObj.put("lastUpdate", lastUpdate.time)
            }

            topicObj.put("isActive", safeGetBoolean(dynTopic, "isActive"))

            topicsJson.put(topicObj)
          } catch (e: Exception) {
            Log.e(TAG, "Error processing Topic: ${e.message}", e)
          }
        }
      } else {
        Log.w(TAG, "Topic schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${topicsJson.length()} Topics from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating Topics from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return topicsJson.toString()
  }

  /**
   * Migrate Picture data from Realm database
   */
  fun migratePictures(realmFilePath: String?): String {
    if (realmFilePath == null) {
      return JSONArray().toString()
    }

    val picturesJson = JSONArray()
    var realm: DynamicRealm? = null

    try {
      val realmFile = File(realmFilePath)
      if (!realmFile.exists()) {
        return picturesJson.toString()
      }

      if (!realmFile.canRead()) {
        Log.w(TAG, "Realm file is not readable, attempting to fix permissions: $realmFilePath")
        try {
          realmFile.setReadable(true, false)
          realmFile.setWritable(true, false)
        } catch (e: Exception) {
          Log.w(TAG, "Could not fix file permissions: ${e.message}")
        }
      }

      Realm.init(context)

      val isEncrypted = isEncryptedRealmFile(realmFilePath)

      val filesDir = context.filesDir
      val configBuilder = if (realmFile.parent == filesDir.absolutePath) {
        RealmConfiguration.Builder().name(realmFile.name)
      } else {
        RealmConfiguration.Builder().name(realmFile.name).directory(realmFile.parentFile)
      }

      if (isEncrypted) {
        val encryptionKey = getEncryptionKey()
        configBuilder.encryptionKey(encryptionKey)
      }

      val config = configBuilder.build()
      realm = DynamicRealm.getInstance(config)

      val schema = realm.schema
      val pictureSchema = schema.get("Picture")
        ?: schema.get("picture")
        ?: schema.get("PictureEntity")

      if (pictureSchema != null) {
        Log.d(TAG, "Found Picture schema: ${pictureSchema.className}")
        val pictures = realm.where(pictureSchema.className).findAll()

        for (picture in pictures) {
          try {
            val pictureObj = JSONObject()
            val dynPicture = picture as DynamicRealmObject

            // Map Realm Picture fields based on REALM_SCHEMA.md:
            // id, user, url, urlHD, symbol, aspectRation
            pictureObj.put("id", safeGetLong(dynPicture, "id"))

            val user = safeGetLong(dynPicture, "user")
            if (user != 0L) pictureObj.put("user", user.toInt())

            val url = safeGetString(dynPicture, "url")
            if (url != null) pictureObj.put("url", url)

            val urlHD = safeGetString(dynPicture, "urlHD")
            if (urlHD != null) pictureObj.put("urlHD", urlHD)

            val symbol = safeGetString(dynPicture, "symbol")
            if (symbol != null) pictureObj.put("symbol", symbol)

            // aspectRation is a float in Realm (note: typo in schema - "aspectRation" not "aspectRatio")
            try {
              if (dynPicture.hasField("aspectRation") && !dynPicture.isNull("aspectRation")) {
                val aspectRation = dynPicture.getFloat("aspectRation")
                pictureObj.put("aspectRation", aspectRation.toDouble())
              }
            } catch (e: Exception) {
              // Field might not exist or be inaccessible, skip silently
            }

            picturesJson.put(pictureObj)
          } catch (e: Exception) {
            Log.e(TAG, "Error processing Picture: ${e.message}", e)
          }
        }
      } else {
        Log.w(TAG, "Picture schema not found. Available schemas: ${schema.all.map { it.className }}")
      }

      Log.d(TAG, "Migrated ${picturesJson.length()} Pictures from Realm")

    } catch (e: Exception) {
      val errorMsg = e.message ?: ""
      if (errorMsg.contains("encrypted Realm file") || errorMsg.contains("invalid mnemonic")) {
        Log.e(TAG, "❌ Realm file appears to be encrypted: $realmFilePath")
        throw Exception("Realm file is encrypted: $realmFilePath")
      } else {
        Log.e(TAG, "Error migrating Pictures from Realm: ${e.message}", e)
        throw e
      }
    } finally {
      realm?.close()
    }

    return picturesJson.toString()
  }
}
