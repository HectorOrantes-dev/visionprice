# Reporte — C3: HTTPS Pinning en Flutter

**Alumno:** _(tu nombre)_
**Materia:** Seguridad de la Información
**Fecha:** _(fecha de entrega)_
**Repositorio:** _(enlace al repo privado de GitHub)_

---

## 1. Objetivo

Proteger una aplicación móvil Flutter contra ataques *Man-in-the-Middle* (MitM)
mediante **SSL/TLS Pinning**, de modo que la app solo se comunique con el
servidor legítimo y rechace conexiones interceptadas por un certificado de un
tercero (proxy).

- **API consumida:** `https://jsonplaceholder.typicode.com/todos/1`
- **Técnica:** *certificate pinning* — el cliente confía **solo** en el
  certificado del servidor legítimo, embebido en la app.
- **Cliente HTTP:** `dio` + `dart:io HttpClient` + `SecurityContext`.

---

## 2. Extracción del certificado / SHA-256 del servidor

**Certificado (PEM)** que se embebe en la app — comando utilizado (OpenSSL):

```bash
echo | openssl s_client -connect jsonplaceholder.typicode.com:443 \
  -servername jsonplaceholder.typicode.com 2>/dev/null \
  | openssl x509 -outform PEM > jsonplaceholder.pem
```

El PEM resultante se fijó en `PinningConfig.pinnedCertificatePem`
(`lib/config/pinning_config.dart`).

**Huella SHA-256** del certificado (referencia/documentación):

```bash
echo | openssl s_client -connect jsonplaceholder.typicode.com:443 \
  -servername jsonplaceholder.typicode.com 2>/dev/null \
  | openssl x509 -outform DER | openssl dgst -sha256
```

Salida obtenida:

```
SHA2-256(stdin)= 6f73ed499d45eef00373fd96a420b119563265c1af9ac0556530898095c77071
```

---

## 3. Lógica de validación (resumen)

`lib/network/api_client.dart`:

```dart
final context = SecurityContext(withTrustedRoots: false)
  ..setTrustedCertificatesBytes(utf8.encode(PinningConfig.pinnedCertificatePem));

dio.httpClientAdapter = IOHttpClientAdapter(
  createHttpClient: () => HttpClient(context: context),
);
```

Con `withTrustedRoots: false` el cliente no confía en ninguna CA del sistema; el
único certificado de confianza es el del servidor legítimo. Por tanto la app
solo completa el handshake si el servidor presenta **exactamente** ese
certificado. Cualquier otro (el del proxy) hace que la cadena no valide y produce
`HandshakeException` (`CERTIFICATE_VERIFY_FAILED`), que la UI captura y muestra
como error controlado ("Conexión BLOQUEADA por pinning").

> **Validación previa (headless).** Se probó la lógica sin proxy con un script:
> el cliente *pinned* conecta al servidor legítimo (**HTTP 200**) y, contra un
> host con otro certificado (simula el intruso), aborta con
> `HandshakeException: CERTIFICATE_VERIFY_FAILED`.

---

## 4. Prueba de Concepto (PoC)

Proxy utilizado: _(HTTP Toolkit / OWASP ZAP / Charles)_

### 4.1 Conexión exitosa (condiciones normales)

Con el pin correcto y sin interceptar (o con pinning activo contra el servidor
legítimo), la app obtiene la respuesta HTTP 200 con el JSON.

> **[ CAPTURA 1 — Conexión exitosa: la app muestra "Conexión exitosa" y el JSON ]**

### 4.2 Bloqueo del MitM

**Sin pinning**, el proxy lee el tráfico (se ve la petición en el proxy).
**Con pinning activado**, la app detecta el certificado intruso y aborta:

> **[ CAPTURA 2 — Bloqueo: la app muestra "Conexión BLOQUEADA por pinning" con
> el log HandshakeException / CERTIFICATE_VERIFY_FAILED ]**

Log esperado en consola:

```
[PINNING] host=jsonplaceholder.typicode.com recibido=<hash del proxy>
          esperado=6f73ed49...5c77071 match=false
```

---

## 5. Conclusión — rotación / expiración del certificado en producción

Fijar el SHA-256 del certificado **hoja** es lo más estricto, pero también lo más
frágil: cuando el servidor rota o renueva su certificado (algo que ocurre cada
pocos meses, p. ej. con Let's Encrypt), el pin deja de coincidir y **todos los
usuarios con la versión vieja de la app quedan bloqueados**. Para evitarlo en
producción se recomienda: (1) **fijar la clave pública (SPKI) de la CA
intermedia** en lugar del certificado hoja, ya que cambia con mucha menos
frecuencia; (2) **embeber varios pines de respaldo** (el actual y el del próximo
certificado/CA) para tener un periodo de solape sin romper nada; y (3) entregar
los pines por **configuración remota firmada** (o forzar actualización de la app)
con suficiente antelación, de modo que la rotación del servidor y la
actualización del pin en los clientes ocurran de forma coordinada y con margen.
