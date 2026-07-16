import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'privacy_block.dart';

/// Título principal del aviso de privacidad. Antes el privado `_Title`.
class PrivacyTitle extends PrivacyBlock {
  final String text;
  const PrivacyTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
            height: 1.3,
          ),
        ),
      );
}
