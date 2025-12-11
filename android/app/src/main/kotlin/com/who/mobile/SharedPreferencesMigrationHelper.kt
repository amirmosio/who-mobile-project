package com.who.mobile

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import org.json.JSONObject
import org.xmlpull.v1.XmlPullParser
import org.xmlpull.v1.XmlPullParserFactory
import java.io.File
import java.io.FileInputStream

/**
 * Helper class to migrate SharedPreferences (authentication data) from the old Android app
 *
 * This reads SharedPreferences from the old app's package and extracts authentication data
 */
class SharedPreferencesMigrationHelper(private val context: Context) {

    companion object {
        private const val TAG = "SharedPrefsMigration"

        // Possible old app package names - update this with the actual old app package name
        private val OLD_APP_PACKAGES = listOf(
            "com.reddoak.guidaevai",
            "com.bokapp.quizpatente",  // In case same package but different storage key
            "com.meraviglia.yourang"
        )

        // Common SharedPreferences keys where auth data might be stored
        // Update these based on how the old app stored auth data
        private val AUTH_KEYS = listOf(
            "user_auth_data",
            "login_response",
            "auth_data",
            "user_auth",
            "jwt_token",
            "access_token",
            "refresh_token",
            "user_token",
            "authentication_data",
            "key_oauth2",  // OAuth2 tokens stored as JSON string
            "CURRENT_USER"  // User info in AccountController.xml
        )
    }

    /**
     * Find the old app's package name by checking which packages are installed
     * Also checks the current app's package name as fallback (in case both apps have same package)
     */
    private fun findOldAppPackage(): String? {
        val packageManager = context.packageManager

        // First, check for different old app packages
        for (packageName in OLD_APP_PACKAGES) {
            try {
                packageManager.getPackageInfo(packageName, 0)
                Log.d(TAG, "Found old app package: $packageName")
                return packageName
            } catch (e: Exception) {
                // Package not found, continue
            }
        }

        // If no old app packages found, check if current app might have old data
        // This can happen if both old and new apps have the same package name
        val currentPackageName = context.packageName
        if (currentPackageName in OLD_APP_PACKAGES) {
            Log.d(TAG, "No separate old app found, checking current app's data directory: $currentPackageName")
            return currentPackageName
        }

        Log.d(TAG, "No old app package found")
        return null
    }

    /**
     * Get SharedPreferences from the old app's package
     *
     * Tries multiple methods:
     * 1. Read XML files from old app's data directory (most reliable - reads ALL files)
     * 2. Access via createPackageContext (fallback - only if file-based method fails)
     *
     * We prioritize file-based method because it reads ALL SharedPreferences XML files,
     * not just the default one. This is important because auth data might be in
     * AccountController.xml, key_oauth2.xml, etc., not just the default prefs file.
     */
    private fun getOldAppSharedPreferences(packageName: String): SharedPreferences? {
        // Method 1: Try to read XML files from old app's data directory (reads ALL files)
        // This is more reliable because it parses all SharedPreferences XML files
        val prefsFromFiles = tryGetSharedPreferencesFromFiles(packageName)
        if (prefsFromFiles != null) {
            Log.d(TAG, "✅ Successfully accessed SharedPreferences via file parsing")
            return prefsFromFiles
        }

        // Method 2: Fallback to package context (if app is installed)
        Log.d(TAG, "File-based method failed, trying to access via package context")
        val prefsFromContext = tryGetSharedPreferencesFromContext(packageName)
        if (prefsFromContext != null) {
            Log.d(TAG, "✅ Successfully accessed SharedPreferences via package context")
            return prefsFromContext
        }

        return null
    }

    /**
     * Try to get SharedPreferences via createPackageContext (works if old app is installed)
     */
    private fun tryGetSharedPreferencesFromContext(packageName: String): SharedPreferences? {
        return try {
            val oldAppContext = context.createPackageContext(
                packageName,
                Context.CONTEXT_IGNORE_SECURITY or Context.MODE_PRIVATE
            )

            // Try common preference file names
            val prefsFileNames = listOf(
                "${packageName}_preferences",
                "user_preferences",
                "app_preferences",
                "shared_preferences",
                "default"
            )

            for (prefsFileName in prefsFileNames) {
                try {
                    val prefs = oldAppContext.getSharedPreferences(prefsFileName, Context.MODE_PRIVATE)
                    // Check if this prefs file has any data
                    if (prefs.all.isNotEmpty()) {
                        Log.d(TAG, "Found SharedPreferences file via context: $prefsFileName")
                        return prefs
                    }
                } catch (e: Exception) {
                    // Try next file name
                }
            }

            // Try default SharedPreferences (most common)
            try {
                val prefs = oldAppContext.getSharedPreferences(
                    "${packageName}_preferences",
                    Context.MODE_PRIVATE
                )
                if (prefs.all.isNotEmpty()) {
                    return prefs
                }
            } catch (e: Exception) {
                Log.d(TAG, "Error accessing default SharedPreferences: ${e.message}")
            }

            null
        } catch (e: Exception) {
            Log.d(TAG, "Error creating package context for $packageName: ${e.message}")
            null
        }
    }

    /**
     * Try to read SharedPreferences XML files directly from old app's data directory
     * This works even if the old app is uninstalled (but files still exist)
     * Note: This requires the old app's data directory to be accessible
     */
    private fun tryGetSharedPreferencesFromFiles(packageName: String): SharedPreferences? {
        return try {
            // SharedPreferences are stored in: /data/data/<package>/shared_prefs/
            val sharedPrefsDir = java.io.File("/data/data/$packageName/shared_prefs")

            if (!sharedPrefsDir.exists() || !sharedPrefsDir.isDirectory) {
                Log.d(TAG, "SharedPreferences directory does not exist: ${sharedPrefsDir.path}")
                return null
            }

            // List all XML files in shared_prefs directory
            val prefsFiles = sharedPrefsDir.listFiles { file ->
                file.isFile && file.name.endsWith(".xml")
            }

            if (prefsFiles == null || prefsFiles.isEmpty()) {
                Log.d(TAG, "No SharedPreferences XML files found in ${sharedPrefsDir.path}")
                return null
            }

            Log.d(TAG, "Found ${prefsFiles.size} SharedPreferences XML file(s) in ${sharedPrefsDir.path}")

            // Parse all XML files and merge into a single map
            val allPrefs = mutableMapOf<String, Any?>()

            for (prefsFile in prefsFiles) {
                try {
                    val parsedPrefs = parseSharedPreferencesXml(prefsFile)
                    allPrefs.putAll(parsedPrefs)
                    Log.d(TAG, "✅ Parsed ${prefsFile.name}: ${parsedPrefs.size} keys")
                } catch (e: Exception) {
                    Log.w(TAG, "⚠️  Failed to parse ${prefsFile.name}: ${e.message}")
                }
            }

            if (allPrefs.isEmpty()) {
                Log.d(TAG, "No preferences found after parsing XML files")
                return null
            }

            // Create a mock SharedPreferences object that returns values from the parsed map
            return MockSharedPreferences(allPrefs)
        } catch (e: Exception) {
            Log.d(TAG, "Error reading SharedPreferences from files: ${e.message}")
            null
        }
    }

    /**
     * Inspect and export all SharedPreferences keys/values from old app
     * Useful for debugging to see what data is actually stored
     */
    fun inspectOldAppSharedPreferences(): String? {
        try {
            val oldPackageName = findOldAppPackage() ?: return null

            val oldPrefs = getOldAppSharedPreferences(oldPackageName) ?: return null

            val allPrefs = oldPrefs.all
            val json = org.json.JSONObject()

            for ((key, value) in allPrefs) {
                when (value) {
                    is String -> json.put(key, value)
                    is Int -> json.put(key, value)
                    is Long -> json.put(key, value)
                    is Float -> json.put(key, value.toDouble())
                    is Boolean -> json.put(key, value)
                    is Set<*> -> json.put(key, org.json.JSONArray((value as Set<String>).toList()))
                    else -> json.put(key, value.toString())
                }
            }

            Log.d(TAG, "Inspected SharedPreferences from $oldPackageName:")
            Log.d(TAG, "Keys: ${allPrefs.keys.joinToString()}")

            return json.toString(2) // Pretty print with 2-space indent
        } catch (e: Exception) {
            Log.e(TAG, "Error inspecting SharedPreferences: ${e.message}", e)
            return null
        }
    }

    /**
     * Migrate authentication data from old app's SharedPreferences
     * Returns JSON string with auth data or null if not found
     */
    fun migrateAuthData(): String? {
        try {
            // Try to find old app package first
            val oldPackageName = findOldAppPackage()
            Log.d(TAG, "Attempting to migrate auth data${if (oldPackageName != null) " from: $oldPackageName" else ""}")

            // Try to get SharedPreferences from old app
            val oldPrefs = if (oldPackageName != null) {
                getOldAppSharedPreferences(oldPackageName)
            } else {
                Log.d(TAG, "Old app not installed, cannot access SharedPreferences")
                null
            }

            if (oldPrefs == null) {
                Log.d(TAG, "No SharedPreferences found in any location")
                return null
            }

            // Try to find auth data in various possible keys
            val authData = JSONObject()
            var foundAnyAuthData = false

            // Check all possible auth keys
            for (key in AUTH_KEYS) {
                if (oldPrefs.contains(key)) {
                    val value = oldPrefs.getString(key, null)
                    if (value != null && value.isNotEmpty()) {
                        authData.put(key, value)
                        foundAnyAuthData = true
                        Log.d(TAG, "Found auth data in key: $key")
                    }
                }
            }

            // Check for key_oauth2 which contains OAuth2 tokens as JSON string
            val oauth2Json = oldPrefs.getString("key_oauth2", null)
            if (oauth2Json != null && oauth2Json.isNotEmpty()) {
                try {
                    val oauth2Data = JSONObject(oauth2Json)
                    val accessToken = oauth2Data.optString("access_token", null)
                    val refreshToken = oauth2Data.optString("refresh_token", null)

                    if (accessToken != null && accessToken.isNotEmpty()) {
                        authData.put("access", accessToken)
                        foundAnyAuthData = true
                        Log.d(TAG, "Found access_token in key_oauth2")
                    }

                    if (refreshToken != null && refreshToken.isNotEmpty()) {
                        authData.put("refresh", refreshToken)
                        foundAnyAuthData = true
                        Log.d(TAG, "Found refresh_token in key_oauth2")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error parsing key_oauth2 JSON: ${e.message}")
                }
            }

            // Check for CURRENT_USER in AccountController (contains user info)
            val currentUserJson = oldPrefs.getString("CURRENT_USER", null)
            if (currentUserJson != null && currentUserJson.isNotEmpty()) {
                try {
                    val userData = JSONObject(currentUserJson)
                    val userEmail = userData.optString("email", null)
                    val userId = userData.optInt("id", 0)
                    val userFirstName = userData.optString("firstname", null)
                    val userSurname = userData.optString("surname", null)

                    val userObject = JSONObject()
                    if (userId > 0) {
                        userObject.put("id", userId)
                        foundAnyAuthData = true
                    }
                    if (userEmail != null && userEmail.isNotEmpty()) {
                        userObject.put("email", userEmail)
                        foundAnyAuthData = true
                    }
                    if (userFirstName != null && userFirstName.isNotEmpty()) {
                        userObject.put("firstname", userFirstName)
                    }
                    if (userSurname != null && userSurname.isNotEmpty()) {
                        userObject.put("surname", userSurname)
                    }

                    if (userObject.length() > 0) {
                        authData.put("user", userObject)
                        Log.d(TAG, "Found user info in CURRENT_USER")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error parsing CURRENT_USER JSON: ${e.message}")
                }
            }

            // Also check for JWT token components separately (fallback)
            val jwtToken = oldPrefs.getString("jwt_token", null)
                ?: oldPrefs.getString("access_token", null)
                ?: oldPrefs.getString("access", null)

            val refreshTokenFallback = oldPrefs.getString("refresh_token", null)
                ?: oldPrefs.getString("refresh", null)

            val userEmail = oldPrefs.getString("user_email", null)
                ?: oldPrefs.getString("email", null)

            val userId = oldPrefs.getString("user_id", null)
                ?: oldPrefs.getString("id", null)

            val userFirstName = oldPrefs.getString("user_first_name", null)
                ?: oldPrefs.getString("first_name", null)
                ?: oldPrefs.getString("firstname", null)

            val userSurname = oldPrefs.getString("user_surname", null)
                ?: oldPrefs.getString("surname", null)
                ?: oldPrefs.getString("last_name", null)

            // Build auth data object (only if not already set from key_oauth2)
            if (!authData.has("access") && jwtToken != null) {
                authData.put("access", jwtToken)
                foundAnyAuthData = true
            }

            if (!authData.has("refresh") && refreshTokenFallback != null) {
                authData.put("refresh", refreshTokenFallback)
                foundAnyAuthData = true
            }

            if (userEmail != null || userId != null) {
                val userObject = JSONObject()
                if (userId != null) {
                    userObject.put("id", userId.toIntOrNull() ?: userId)
                }
                if (userEmail != null) {
                    userObject.put("email", userEmail)
                }
                if (userFirstName != null) {
                    userObject.put("firstname", userFirstName)
                }
                if (userSurname != null) {
                    userObject.put("surname", userSurname)
                }

                if (userObject.length() > 0) {
                    authData.put("user", userObject)
                    foundAnyAuthData = true
                }
            }

            // If we found a complete auth JSON string, parse and return it
            val completeAuthJson = oldPrefs.getString("user_auth_data", null)
                ?: oldPrefs.getString("login_response", null)
                ?: oldPrefs.getString("auth_data", null)

            if (completeAuthJson != null && completeAuthJson.isNotEmpty()) {
                Log.d(TAG, "Found complete auth JSON string")
                return completeAuthJson
            }

            // Otherwise, return the reconstructed auth data
            if (foundAnyAuthData) {
                Log.d(TAG, "Reconstructed auth data from individual keys")
                return authData.toString()
            }

            Log.d(TAG, "No auth data found in old app's SharedPreferences")
            return null

        } catch (e: Exception) {
            Log.e(TAG, "Error migrating auth data: ${e.message}", e)
            return null
        }
    }

    /**
     * Check if old app exists and has auth data
     */
    fun hasOldAppAuthData(): Boolean {
        return migrateAuthData() != null
    }

    /**
     * Parse a SharedPreferences XML file and return a map of key-value pairs
     */
    private fun parseSharedPreferencesXml(xmlFile: File): Map<String, Any?> {
        val prefs = mutableMapOf<String, Any?>()

        try {
            val factory = XmlPullParserFactory.newInstance()
            factory.isNamespaceAware = false
            val parser = factory.newPullParser()

            FileInputStream(xmlFile).use { inputStream ->
                parser.setInput(inputStream, "UTF-8")

                var eventType = parser.eventType
                var currentKey: String? = null
                var currentValue: StringBuilder? = null

                while (eventType != XmlPullParser.END_DOCUMENT) {
                    when (eventType) {
                        XmlPullParser.START_TAG -> {
                            val tagName = parser.name
                            if (tagName == "string" || tagName == "int" || tagName == "long" ||
                                tagName == "boolean" || tagName == "float") {
                                currentKey = parser.getAttributeValue(null, "name")
                                currentValue = StringBuilder()
                            }
                        }
                        XmlPullParser.TEXT -> {
                            if (currentKey != null && currentValue != null) {
                                currentValue.append(parser.text)
                            }
                        }
                        XmlPullParser.END_TAG -> {
                            val tagName = parser.name
                            if (tagName == "string" || tagName == "int" || tagName == "long" ||
                                tagName == "boolean" || tagName == "float") {
                                if (currentKey != null && currentValue != null) {
                                    val value = currentValue.toString().trim()
                                    if (value.isNotEmpty()) {
                                        // Store as string for now - MockSharedPreferences will handle type conversion
                                        prefs[currentKey] = value
                                    }
                                }
                                currentKey = null
                                currentValue = null
                            }
                        }
                    }
                    eventType = parser.next()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing XML file ${xmlFile.name}: ${e.message}", e)
            throw e
        }

        return prefs
    }
}

/**
 * Mock SharedPreferences implementation that reads from a map
 * This is used when reading from backup XML files
 */
private class MockSharedPreferences(private val prefs: Map<String, Any?>) : SharedPreferences {

    override fun contains(key: String): Boolean = prefs.containsKey(key)

    override fun edit(): SharedPreferences.Editor {
        throw UnsupportedOperationException("MockSharedPreferences is read-only")
    }

    override fun getAll(): Map<String, *> = prefs

    override fun getBoolean(key: String, defValue: Boolean): Boolean {
        return when (val value = prefs[key]) {
            is Boolean -> value
            is String -> value.toBoolean()
            "true" -> true
            "false" -> false
            else -> defValue
        }
    }

    override fun getFloat(key: String, defValue: Float): Float {
        return when (val value = prefs[key]) {
            is Float -> value
            is Double -> value.toFloat()
            is Number -> value.toFloat()
            is String -> value.toFloatOrNull() ?: defValue
            else -> defValue
        }
    }

    override fun getInt(key: String, defValue: Int): Int {
        return when (val value = prefs[key]) {
            is Int -> value
            is Long -> value.toInt()
            is Number -> value.toInt()
            is String -> value.toIntOrNull() ?: defValue
            else -> defValue
        }
    }

    override fun getLong(key: String, defValue: Long): Long {
        return when (val value = prefs[key]) {
            is Long -> value
            is Int -> value.toLong()
            is Number -> value.toLong()
            is String -> value.toLongOrNull() ?: defValue
            else -> defValue
        }
    }

    override fun getString(key: String, defValue: String?): String? {
        return when (val value = prefs[key]) {
            is String -> value
            is Number -> value.toString()
            null -> defValue
            else -> value.toString()
        }
    }

    override fun getStringSet(key: String, defValues: Set<String>?): Set<String>? {
        // SharedPreferences XML doesn't support string sets directly
        // This would need additional parsing logic
        return defValues
    }

    override fun registerOnSharedPreferenceChangeListener(listener: SharedPreferences.OnSharedPreferenceChangeListener) {
        // Mock implementation - no-op
    }

    override fun unregisterOnSharedPreferenceChangeListener(listener: SharedPreferences.OnSharedPreferenceChangeListener) {
        // Mock implementation - no-op
    }
}
