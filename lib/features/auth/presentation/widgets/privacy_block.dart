import 'package:flutter/material.dart';

/// Un bloque de contenido del aviso de privacidad. Cada variante se renderiza
/// con su propio estilo (título, sección, párrafo, viñeta o nota destacada).
/// Antes el privado `_Block`.
abstract class PrivacyBlock {
  const PrivacyBlock();
  Widget build(BuildContext context);
}
