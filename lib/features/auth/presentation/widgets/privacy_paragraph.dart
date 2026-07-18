import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'privacy_block.dart';

/// Párrafo de texto del aviso de privacidad. Antes el privado `_Paragraph`.
class PrivacyParagraph extends PrivacyBlock {
  final String text;
  const PrivacyParagraph(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: context.colors.textSecondary,
            height: 1.6,
          ),
        ),
      );
}
