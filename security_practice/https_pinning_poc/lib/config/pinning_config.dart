/// Configuración del pinning: API de destino y el **certificado** del servidor
/// en el que confiamos (SSL/TLS pinning por certificado).
///
/// El certificado se extrajo del servidor real con OpenSSL (ver README.md):
///
/// ```bash
/// echo | openssl s_client -connect jsonplaceholder.typicode.com:443 \
///   -servername jsonplaceholder.typicode.com 2>/dev/null \
///   | openssl x509 -outform PEM
/// ```
///
/// Y su huella SHA-256 (a modo de referencia / documentación):
///
/// ```bash
/// echo | openssl s_client -connect jsonplaceholder.typicode.com:443 \
///   -servername jsonplaceholder.typicode.com 2>/dev/null \
///   | openssl x509 -outform DER | openssl dgst -sha256
/// # 6f73ed499d45eef00373fd96a420b119563265c1af9ac0556530898095c77071
/// ```
class PinningConfig {
  /// API pública HTTPS que consume la app (sin autenticación, JSON simple).
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/todos/1';

  /// Host del servidor legítimo.
  static const String host = 'jsonplaceholder.typicode.com';

  /// SHA-256 del certificado HOJA (DER), solo informativo/para el reporte.
  static const String pinnedSha256 =
      '6f73ed499d45eef00373fd96a420b119563265c1af9ac0556530898095c77071';

  /// Certificado HOJA del servidor legítimo (PEM). Es el ÚNICO certificado en
  /// el que confiará el cliente "pinned": si el servidor presenta otro (p. ej.
  /// el de un proxy MitM), el handshake se aborta.
  ///
  /// Si el servidor rota su certificado, este PEM debe actualizarse
  /// (ver la sección de rotación en REPORT.md).
  static const String pinnedCertificatePem = '''
-----BEGIN CERTIFICATE-----
MIIDpzCCA06gAwIBAgIQNsOcG511ARAO84o146B25DAKBggqhkjOPQQDAjA7MQsw
CQYDVQQGEwJVUzEeMBwGA1UEChMVR29vZ2xlIFRydXN0IFNlcnZpY2VzMQwwCgYD
VQQDEwNXRTEwHhcNMjYwNTMxMjE0NTM4WhcNMjYwODI5MjI0NDE1WjAXMRUwEwYD
VQQDEwx0eXBpY29kZS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARXI3Cy
K+e2njJz7jnofcB5x+7EjPWH7OmqkTMNVJURsoLmrCaJyCb4YYpYXphP7xS2YYk9
SfndpYNbBPviX1wYo4ICVjCCAlIwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoG
CCsGAQUFBwMBMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFFbOvadllsz0XHBJZ+p9
kkmP2FxxMB8GA1UdIwQYMBaAFJB3kjVnxP+ozKnme9mAeXvMk/k4MF4GCCsGAQUF
BwEBBFIwUDAnBggrBgEFBQcwAYYbaHR0cDovL28ucGtpLmdvb2cvcy93ZTEvTnNN
MCUGCCsGAQUFBzAChhlodHRwOi8vaS5wa2kuZ29vZy93ZTEuY3J0MCcGA1UdEQQg
MB6CDHR5cGljb2RlLmNvbYIOKi50eXBpY29kZS5jb20wEwYDVR0gBAwwCjAIBgZn
gQwBAgEwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2MucGtpLmdvb2cvd2UxL09o
TVpqbVQxQmZZLmNybDCCAQUGCisGAQQB1nkCBAIEgfYEgfMA8QB2AMijxH/Hs625
NWsBP2p6Em3jOk5DpcZG+ZetOXWZHc+aAAABnoA22GUAAAQDAEcwRQIhAIfWAMz9
mFw/4x2UPHVpM0/z+IqGCYA92eXO+9oQSRWeAiA6H1K/uA0ORkcXCeCfzkDJhl25
BgbNmlGz5pGf5qXMRAB3ANdtfRDRp/V3wsfpX9cAv/mCyTNaZeHQswFzF8DIxWl3
AAABnoA22EgAAAQDAEgwRgIhAMTS1nYV41rajr/51hOyXrNmX06b3HrBRA8yVl29
QQR5AiEArf9BUkdeOcUlAJGKd5h2c+n+Vnpmlbn/R7vzsST4FgEwCgYIKoZIzj0E
AwIDRwAwRAIgdFvB2dDhOecCzIWiTt9aCEWuUaRaGEviCA4EmgoFBv0CIEGT0XQz
lnMNAyhXFMBesltvN8eNYuw7WJMOGSD6iGwt
-----END CERTIFICATE-----
''';
}
