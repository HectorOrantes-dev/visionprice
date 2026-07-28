/// Mixin con validadores puros y reutilizables de formularios.
///
/// Se "mezcla" en los ViewModels (`with ValidationMixin`) para compartir la
/// lógica de validación sin herencia ni duplicación. Son funciones sin estado:
/// reciben un valor y devuelven el mensaje de error (o `null` si es válido).
mixin ValidationMixin {
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Al menos una letra (con acentos/ñ) o dígito — usarlo para rechazar
  /// entradas que son solo puntuación/espacios (`"..."`, `";"`, `"---"`,
  /// `"   "`), que de otro modo pasaban cualquier validador que solo
  /// revisara longitud tras `trim()`.
  static final RegExp _contenidoReal = RegExp(r'[a-zA-Z0-9À-ÿ]', unicode: true);

  bool _tieneContenidoReal(String value) => _contenidoReal.hasMatch(value);

  String? validateEmail(String value) {
    if (value.isEmpty) return 'El correo es obligatorio';
    if (!_emailRegex.hasMatch(value)) return 'Ingresa un correo válido';
    final partes = value.split('@');
    // La regex estructural deja pasar cosas como "...@...com" (puros puntos
    // antes de la arroba) — exige que cada lado tenga contenido real.
    if (partes.length != 2 ||
        !_tieneContenidoReal(partes[0]) ||
        !_tieneContenidoReal(partes[1])) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  /// Valida una lista de correos separados por coma (usado en "Invitar" —
  /// varios destinatarios a la vez). Devuelve el mensaje del primero que
  /// falle, o `null` si todos son válidos (lista vacía cuenta como válida:
  /// el campo es opcional).
  String? validateEmailList(List<String> correos) {
    for (final correo in correos) {
      final error = validateEmail(correo);
      if (error != null) return '"$correo": $error';
    }
    return null;
  }

  String? validateName(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'El nombre es obligatorio';
    if (v.length < 3) return 'Mínimo 3 caracteres';
    if (!_tieneContenidoReal(v)) return 'Ingresa un nombre válido';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    return null;
  }

  String? validateCode(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'Ingresa el código';
    if (v.length < 4) return 'Código incompleto';
    if (!_tieneContenidoReal(v)) return 'Ingresa un código válido';
    return null;
  }

  String? validateProjectName(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'El nombre es obligatorio';
    if (v.length < 2) return 'Escribe un nombre (mín. 2 caracteres)';
    if (!_tieneContenidoReal(v)) return 'Ingresa un nombre válido';
    return null;
  }

  /// Campo de texto libre pero opcional (p. ej. dirección): si viene vacío
  /// no truena (es opcional), pero si viene con algo, ese algo debe ser
  /// contenido real, no solo puntuación/espacios.
  String? validateOptionalText(String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    if (!_tieneContenidoReal(v)) {
      return 'Quita los símbolos, escribe texto real';
    }
    return null;
  }

  /// Campo de texto libre pero OBLIGATORIO (p. ej. la transcripción editada
  /// de un audio): rechaza vacío y también puro símbolo/espacio.
  String? validateRequiredText(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'Este campo es obligatorio';
    if (!_tieneContenidoReal(v)) return 'Escribe texto real, no solo símbolos';
    return null;
  }

  /// Teléfono: al menos 10 dígitos (México sin lada de país), tolera
  /// espacios/guiones/paréntesis/`+` como separadores, pero nada más.
  String? validatePhone(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'El teléfono es obligatorio';
    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(v)) {
      return 'Solo números, espacios y +/-()';
    }
    final digitos = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.length < 10) return 'Ingresa un teléfono válido (10 dígitos)';
    return null;
  }
}
