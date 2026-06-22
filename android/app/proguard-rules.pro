# ============================================================================
#  Reglas ProGuard / R8 para VisionPrice
#  Práctica: Ofuscación de código en aplicaciones móviles.
#
#  R8 renombra clases/métodos/campos y elimina código no usado. Las clases
#  que se acceden por reflexión o desde código nativo NO deben renombrarse:
#  para esos casos usamos reglas `-keep`.
# ============================================================================

# ─── Flutter engine y embedding ───────────────────────────────────────────
# El motor de Flutter accede a estas clases por reflexión / JNI.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# ─── MainActivity y el canal nativo de RASP ───────────────────────────────
# El MethodChannel "com.visionprice.vision_price/rasp" se invoca por nombre.
-keep class com.visionprice.vision_price.MainActivity { *; }

# ─── Firebase (Core + Messaging) ──────────────────────────────────────────
# Firebase usa reflexión para registrar componentes y deserializar mensajes.
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# ─── flutter_local_notifications ──────────────────────────────────────────
-keep class com.dexterous.** { *; }

# ─── Plugins de seguridad (safe_device, geolocator, permission_handler) ────
# Suelen funcionar sin reglas extra, pero conservamos sus puntos de entrada.
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }

# ─── Modelos serializados con Gson/JSON (si se usan vía reflexión) ─────────
# Conserva anotaciones y nombres de campos en clases de datos.
-keepattributes *Annotation*
-keepattributes Signature
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ─── Mantener números de línea para depurar stack traces ofuscados ─────────
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
