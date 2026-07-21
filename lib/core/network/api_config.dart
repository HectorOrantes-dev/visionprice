/// Configuración central del back-end.
///
/// `baseUrl` apunta al API Gateway (único punto de entrada; reenvía a la API
/// principal y a Pagos/2FA/Proveedores/Extracciones según el prefijo — ver
/// el repo api-gateway). Cámbialo por otra URL con
/// `--dart-define=API_BASE_URL=...` si hace falta (ej. apuntar a la API
/// principal directo para debug local, ya que el gateway todavía acepta
/// tráfico sin pasar por él — modo dual-accept).
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://apigetwayvisionprice-production.up.railway.app',
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
  static const String cotizacionesBorrador = '$apiPrefix/cotizaciones/borrador';

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

  // --- Auditoría de precios (exclusiva Ingeniero Civil) ---
  static String auditoriaPrecioPresupuesto(int presupuestoId) =>
      '$apiPrefix/auditoria/precios/presupuestos/$presupuestoId';
  static const String auditoriaPrecioAnomalias =
      '$apiPrefix/auditoria/precios/anomalias';

  // --- Pagos (Conekta / PayPal, vía micro Pagos detrás del gateway) ---
  static const String conektaSubscriptions =
      '$apiPrefix/pagos-ms/conekta/subscriptions';
  static const String conektaSubscriptionsCancel =
      '$apiPrefix/pagos-ms/conekta/subscriptions/cancel';
  static const String conektaPaymentMethod =
      '$apiPrefix/pagos-ms/conekta/payment-method';
  static const String paypalSubscriptions =
      '$apiPrefix/pagos-ms/paypal/subscriptions';
  static String paypalSubscriptionCancel(String subscriptionId) =>
      '$apiPrefix/paypal/subscriptions/$subscriptionId/cancel';

  /// Public/Publishable Key de Conekta (segura para el cliente, a propósito:
  /// solo puede tokenizar tarjetas, nunca cobrar ni consultar cuentas — por
  /// eso SÍ está bien que viaje embebida en el binario que sube a Play
  /// Store, igual que la `pk_` de Stripe). La Private Key, en cambio, jamás
  /// debe tocar este repo: esa vive solo en el back-end (Pagos).
  /// Se puede pisar con `--dart-define=CONEKTA_PUBLIC_KEY=...` para apuntar
  /// a otra llave (ej. una de test) sin tocar código.
  static const String conektaPublicKey = String.fromEnvironment(
    'CONEKTA_PUBLIC_KEY',
    defaultValue: 'key_JDVfvP3r18wnhkFik8Iyq3n',
  );

  // URLs de retorno de PayPal (configuradas también en el back-end de Pagos):
  // el WebView de aprobación intercepta la navegación hacia estas rutas para
  // saber que el usuario terminó el flujo, sin esperar a un deep link.
  static const String paypalReturnUrl =
      'https://app.visionprice.mx/pagos/paypal/return';
  static const String paypalCancelUrl =
      'https://app.visionprice.mx/pagos/paypal/cancel';
}
