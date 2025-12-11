-keep class com.hiennv.flutter_callkit_incoming.** { *; }

# Flutter Sound ProGuard Rules
-keep class com.dooboolab.fluttersound.** { *; }
-keep class com.dooboolab.** { *; }

# Audio and Media Framework Rules
-keep class android.media.** { *; }
-keep class android.media.audiofx.** { *; }
-keep class androidx.media.** { *; }

# Native Audio Libraries
-keep class org.webrtc.** { *; }
-keep class org.conscrypt.** { *; }

# Flutter Engine Audio
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# Audio Session and Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.ryanheise.audio_session.** { *; }

# SoLoud Audio Engine
-keep class com.alnitak.flutter_soloud.** { *; }

# Google Play Core (Dynamic Features) - Fix R8 missing classes
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Flutter Deferred Components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn java.beans.ConstructorProperties
-dontwarn java.beans.Transient
-dontwarn org.conscrypt.Conscrypt
-dontwarn org.conscrypt.OpenSSLProvider
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry
