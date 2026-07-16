import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'privacy_block.dart';

/// Encabezado de sección del aviso de privacidad. Antes el privado `_Section`.
class PrivacySection extends PrivacyBlock {
  final String text;
  const PrivacySection(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: context.colors.primary,
            height: 1.4,
          ),
        ),
      );
}
