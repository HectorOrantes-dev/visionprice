/// Mixin con validadores puros y reutilizables de formularios.
///
/// Se "mezcla" en los ViewModels (`with ValidationMixin`) para compartir la
/// lógica de validación sin herencia ni duplicación. Son funciones sin estado:
/// reciben un valor y devuelven el mensaje de error (o `null` si es válido).
mixin ValidationMixin {
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String? validateEmail(String value) {
    if (value.isEmpty) return 'El correo es obligatorio';
    if (!_emailRegex.hasMatch(value)) return 'Ingresa un correo válido';
    return null;
  }

  String? validateName(String value) {
    if (value.trim().isEmpty) return 'El nombre es obligatorio';
    if (value.trim().length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    return null;
  }

  String? validateCode(String value) {
    if (value.isEmpty) return 'Ingresa el código';
    if (value.trim().length < 4) return 'Código incompleto';
    return null;
  }
}
