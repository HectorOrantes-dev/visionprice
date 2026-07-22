import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Canal Android de alta importancia (Android 8+) para mostrar la notificación
/// como popup en la barra.
const AndroidNotificationChannel kHighImportanceChannel =
    AndroidNotificationChannel(
  'high_importance_channel',
  'Notificaciones Importantes',
  description: 'Canal usado para las notificaciones importantes.',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Handler de mensajes en SEGUNDO PLANO / app cerrada.
/// Debe ser top-level y llevar @pragma para no ser eliminado en release.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {/* sin config: ignorar */}
  debugPrint('📩 Mensaje en segundo plano: ${message.messageId}');
}

/// Servicio que centraliza Firebase Messaging y la señal remota WIPE_DATA.
///
/// **Inicialización segura:** si Firebase no está configurado (falta
/// google-services.json / config web), `init()` no lanza — la app corre
/// igual, solo sin push hasta configurar Firebase.
class NotificationService {
  NotificationService._();

  static bool _firebaseReady = false;
  static bool get isReady => _firebaseReady;

  /// Inicializa Firebase + notificaciones locales + listeners. Nunca lanza.
  static Future<void> init() async {
    try {
      await Firebase.initializeApp();
      _firebaseReady = true;
    } catch (e) {
      debugPrint('⚠️ Firebase no configurado, push deshabilitado: $e');
      _firebaseReady = false;
      return; // Sin Firebase no seguimos con FCM.
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    const AndroidInitializationSettings initAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: initAndroid);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(kHighImportanceChannel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    _setupForegroundListener();
  }

  /// Devuelve el token FCM del dispositivo (o null si Firebase no está listo).
  static Future<String?> getToken() async {
    if (!_firebaseReady) return null;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('🔥 FCM TOKEN: $token');
      return token;
    } catch (e) {
      debugPrint('❌ Error al obtener token: $e');
      return null;
    }
  }

  static void _setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              kHighImportanceChannel.id,
              kHighImportanceChannel.name,
              channelDescription: kHighImportanceChannel.description,
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }

      // Señal de borrado remoto: en DATA o en el BODY de la notificación.
      if (message.data['action'] == 'WIPE_DATA' ||
          message.notification?.body == 'WIPE_DATA') {
        debugPrint('🔥 SEÑAL WIPE_DATA detectada');
        wipeSensitiveData();
      }
    });
  }

  /// Borra los datos sensibles locales (SharedPreferences).
  static Future<void> wipeSensitiveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint('✅ Datos sensibles borrados.');
  }
}
