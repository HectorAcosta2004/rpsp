# ================================
# Flutter
# ================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# ================================
# Firebase & Google Play Services
# ================================
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.messaging.**

# Firestore
-keep class com.google.firestore.** { *; }
-dontwarn com.google.firestore.**

# Analytics
-keep class com.google.android.gms.measurement.** { *; }
-dontwarn com.google.android.gms.measurement.**

# ================================
# Google Play Core / API Client
# ================================
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-dontwarn com.google.api.client.http.**
-dontwarn org.joda.time.Instant

# ================================
# Facebook Infer annotations
# ================================
-dontwarn com.facebook.infer.annotation.**
-keep class com.facebook.infer.annotation.** { *; }

# ================================
# Kotlin coroutines (para evitar warnings)
# ================================
-dontwarn kotlinx.coroutines.**


# ================================
# OneSignal
# ================================
# Reglas necesarias para el SDK de OneSignal
-keep class com.onesignal.** { *; }

# ================================
# AppLovin MAX / Google Mobile Ads
# ================================
# Reglas para Google Mobile Ads y AppLovin MAX
-keep class com.applovin.mediation.adapters.** { *; }
-keep class com.applovin.sdk.** { *; }
-keep class com.applovin.sdk.AppLovinSdk { *; }
-keep class com.applovin.** { *; }
-keep class com.google.android.gms.internal.ads.** {*;}
-keep class com.google.ads.mediation.** {*;}

# ================================
# Hive (serialización)
# ================================
-keep class ** extends io.flutter.plugins.** { *; }
-keep class ** extends com.google.protobuf.GeneratedMessageLite { *; }
# Reglas para asegurar que las clases de Hive no sean ofuscadas.
-keep class * extends com.applovin.mediation.adapters.applovin.** { *; }
-keep class com.applovin.mediation.adapters.** { *; }
-keep class com.applovin.sdk.** { *; }
-keep class com.applovin.sdk.AppLovinSdk { *; }
-keep class com.applovin.** { *; }
-keep class com.google.android.gms.internal.ads.** {*;}
-keep class com.google.ads.mediation.** {*;}
-keep class com.onesignal.** { *; }
-keep class * extends com.applovin.mediation.adapters.applovin.** { *; }
-keep class com.applovin.mediation.adapters.** { *; }
-keep class com.applovin.sdk.** { *; }
-keep class com.applovin.sdk.AppLovinSdk { *; }
-keep class com.applovin.** { *; }
-keep class com.google.android.gms.internal.ads.** {*;}
-keep class com.google.ads.mediation.** {*;}
-keep class com.onesignal.** { *; }