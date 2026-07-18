import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'privacy_block.dart';

/// Nota destacada (recuadro) del aviso de privacidad. Antes el privado `_Note`.
class PrivacyNote extends PrivacyBlock {
  final String text;
  const PrivacyNote(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.colors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.border),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.5,
              color: context.colors.textPrimary,
              height: 1.6,
            ),
          ),
        ),
      );
}
