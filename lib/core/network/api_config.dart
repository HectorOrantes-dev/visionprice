/// Configuración central del back-end.
///
/// `baseUrl` apunta por defecto a `10.0.2.2`, que es como el emulador de
/// Android alcanza el `localhost` de la máquina anfitriona. Cámbialo por la
/// URL real (o pásalo por `--dart-define=API_BASE_URL=...`).
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://visionpricebackend-production.up.railway.app',
  );

  static const String apiPrefix = '/api/v1';

  // --- Auth ---
  static const String register = '$apiPrefix/auth/register';
  static const String login = '$apiPrefix/auth/login';
  static const String loginVerify = '$apiPrefix/auth/login/verify';
  static const String googleLogin = '$apiPrefix/auth/google/login';
  static const String googleRegister = '$apiPrefix/auth/google/register';
  static const String passwordForgot = '$apiPrefix/auth/password/forgot';
  static const String passwordVerifyCode =
      '$apiPrefix/auth/password/verify-code';
  static const String passwordReset = '$apiPrefix/auth/password/reset';

  // Salud del back-end (raíz, sin prefijo) — para verificar conectividad real.
  static const String health = '/health';

  // --- Catálogos / cuenta ---
  static const String roles = '$apiPrefix/roles';
  static const String me = '$apiPrefix/me';
  static const String mePerfil = '$apiPrefix/me/perfil';
  static const String meSubscriptions = '$apiPrefix/me/subscriptions';

  // --- Proyectos ---
  static const String proyectos = '$apiPrefix/proyectos';
  static String proyecto(int id) => '$apiPrefix/proyectos/$id';

  // --- Collaboration (Miembros e Invitaciones) ---
  static String proyectoMiembros(int id) => '$apiPrefix/proyectos/$id/miembros';
  static String proyectoMiembro(int id, int uid) => '$apiPrefix/proyectos/$id/miembros/$uid';
  static String proyectoInvitaciones(int id) => '$apiPrefix/proyectos/$id/invitaciones';
  static String proyectoInvitacionRevocar(int id, int invId) => '$apiPrefix/proyectos/$id/invitaciones/$invId';
  static const String proyectosUnirse = '$apiPrefix/proyectos/unirse';

  // --- Grabaciones (flujo de audio del maestro de obra) ---
  static const String grabaciones = '$apiPrefix/grabaciones';
  static String grabacion(int id) => '$apiPrefix/grabaciones/$id';
  static String grabacionTranscripcion(int id) => '$apiPrefix/grabaciones/$id/transcripcion';

  // --- Cotizaciones ---
  static const String cotizacionesCalculo = '$apiPrefix/cotizaciones/calculo';
  static const String cotizaciones = '$apiPrefix/cotizaciones';
  static const String cotizacionesProductos = '$apiPrefix/cotizaciones/productos';
  static const String cotizacionesMateriales = '$apiPrefix/cotizaciones/materiales';
  static const String cotizacionesKit = '$apiPrefix/cotizaciones/kit';
  static String cotizacionPdf(int id) => '$apiPrefix/cotizaciones/$id/pdf';
  static const String cotizacionesPdfs = '$apiPrefix/cotizaciones/pdfs';

  // --- Recomendaciones (modelo de kits) ---
  static const String recomendacionesEntrenar =
      '$apiPrefix/recomendaciones/entrenar';
  static const String recomendacionesKit = '$apiPrefix/recomendaciones/kit';

  // --- Notificaciones ---
  static const String notificaciones = '$apiPrefix/notificaciones';
  static String notificacionLeida(int id) =>
      '$apiPrefix/notificaciones/$id/leida';

  // --- Dispositivos (push FCM) ---
  static const String dispositivos = '$apiPrefix/dispositivos';
}
