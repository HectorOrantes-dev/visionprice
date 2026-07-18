# HTTPS / SSL-TLS Pinning en Flutter (PoC)

Práctica **C3 – HTTPS Pinning**. App Flutter que consume una API pública por
HTTPS y valida **estrictamente** el certificado del servidor para rechazar
ataques *Man-in-the-Middle* (MitM).

- **API:** `https://jsonplaceholder.typicode.com/todos/1`
- **Técnica:** *certificate pinning* — se confía **solo** en el certificado del
  servidor legítimo, embebido en la app, con `dio` + `SecurityContext`.
- **Paquetes:** `dio`.

## Cómo funciona el pinning

`lib/network/api_client.dart` construye el cliente HTTP así:

```dart
final context = SecurityContext(withTrustedRoots: false)
  ..setTrustedCertificatesBytes(utf8.encode(PinningConfig.pinnedCertificatePem));

dio.httpClientAdapter = IOHttpClientAdapter(
  createHttpClient: () => HttpClient(context: context),
);
```

- `withTrustedRoots: false` → el sistema **no** confía en ninguna CA por defecto.
- `setTrustedCertificatesBytes(...)` añade como **único** certificado de confianza
  el del servidor legítimo (`lib/config/pinning_config.dart`).
- Así, el handshake solo se completa si el servidor presenta **exactamente** ese
  certificado. Cualquier otro (el del proxy) hace que la cadena no valide →
  `HandshakeException` (`CERTIFICATE_VERIFY_FAILED`) → la app lo captura y muestra
  un **error controlado**.
- Es un método **determinista** y con el mismo comportamiento en Android/iOS
  (a diferencia de comparar `SHA-256` dentro de `badCertificateCallback`, cuyo
  certificado expuesto varía según la plataforma).

El *switch* de la UI permite alternar entre:
- **Pinning ON** → `ApiClient.pinned()` (bloquea el MitM).
- **Pinning OFF** → `ApiClient.unpinned()` (cliente normal, interceptable).

## Extraer el certificado del servidor

Certificado (PEM) que se embebe en `PinningConfig.pinnedCertificatePem`:

```bash
echo | openssl s_client -connect jsonplaceholder.typicode.com:443 \
  -servername jsonplaceholder.typicode.com 2>/dev/null \
  | openssl x509 -outform PEM
```

Huella SHA-256 (referencia/documentación en `PinningConfig.pinnedSha256`):

```bash
echo | openssl s_client -connect jsonplaceholder.typicode.com:443 \
  -servername jsonplaceholder.typicode.com 2>/dev/null \
  | openssl x509 -outform DER | openssl dgst -sha256
```

## Ejecutar

```bash
flutter pub get
flutter run           # con un emulador o dispositivo conectado
```

## Prueba de Concepto (MitM)

Necesitas un proxy: **HTTP Toolkit**, **OWASP ZAP** o **Charles**.

### 1. Sin pinning (el proxy lee el tráfico)
1. Configura el proxy y **instala su CA** en el dispositivo/emulador.
2. En la app pon el switch **Pinning: DESACTIVADO**.
3. Pulsa **Consultar API** → la petición funciona y **aparece en el proxy**
   (tráfico interceptado). *Captura 1.*

### 2. Con pinning (bloqueo)
1. Con el proxy aún interceptando, pon el switch **Pinning: ACTIVADO**.
2. Pulsa **Consultar API** → la app muestra en rojo
   **"Conexión BLOQUEADA por pinning"** con el `HandshakeException`
   (`CERTIFICATE_VERIFY_FAILED`). *Captura 2.*

> Nota Android: `res/xml/network_security_config.xml` confía en CAs de usuario
> **solo** para poder demostrar el MitM sin pinning. Aun confiando en la CA del
> proxy, el pinning bloquea la conexión porque compara el SHA-256.

## Estructura

```
lib/
  config/pinning_config.dart   # URL, host y SHA-256 fijado
  network/api_client.dart      # clientes dio: pinned() y unpinned()
  main.dart                    # UI con switch de pinning y resultado
```
