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

  // --- Catálogos / cuenta ---
  static const String roles = '$apiPrefix/roles';
  static const String me = '$apiPrefix/me';
}
