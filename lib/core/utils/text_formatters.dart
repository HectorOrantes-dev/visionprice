import 'package:flutter/services.dart';

/// Formateadores de entrada reutilizables para campos de texto libre
/// (nombre, dirección, etc.): bloquean caracteres que nunca pertenecen a un
/// nombre real ANTES de que lleguen al controller — a diferencia de
/// `ValidationMixin` (que valida el string ya completo), esto impide
/// teclear el caracter en primer lugar.
final List<TextInputFormatter> kNoSymbolsFormatters = [
  FilteringTextInputFormatter.deny(RegExp(r'["\x27;`<>{}\\]')),
];
