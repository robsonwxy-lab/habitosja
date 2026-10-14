# ==============================================================================
# FLUTTER CORE & PLAY CORE (RESOLVE O ERRO DE MISSING CLASSES DO R8)
# ==============================================================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**
-dontwarn io.flutter.embedding.**

# Ignorar classes do Play Core não utilizadas pelo app
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-ignorewarnings

# ==============================================================================
# DESPERTADOR, ALARMES E NOTIFICAÇÕES (FLUTTER LOCAL NOTIFICATIONS)
# Impede o R8 de remover receptores nativos em segundo plano e com o ecrã desligado
# ==============================================================================
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class androidx.core.app.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-dontwarn com.dexterous.flutterlocalnotifications.**

# ==============================================================================
# GOOGLE PLAY BILLING (PAGAMENTOS, PLANO MENSAL E VITALÍCIO)
# ==============================================================================
-keep class com.android.vending.billing.** { *; }
-keep class com.android.billingclient.api.** { *; }
-dontwarn com.android.billingclient.api.**

# ==============================================================================
# UNITY LEVELPLAY MEDIATION & ANÚNCIOS
# ==============================================================================
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keep class com.ironsource.mediationsdk.** { *; }
-keep class com.ironsource.adapters.** { *; }
-keep class com.unity3d.services.** { *; }
-keep class com.unity3d.ads.** { *; }
-dontwarn com.ironsource.mediationsdk.**
-dontwarn com.ironsource.adapters.**
-dontwarn com.unity3d.services.**

# ==============================================================================
# GOOGLE PLAY SERVICES E FIREBASE
# ==============================================================================
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**