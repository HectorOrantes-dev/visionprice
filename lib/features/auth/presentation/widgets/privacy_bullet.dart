import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'privacy_block.dart';

/// Viñeta (punto) del aviso de privacidad. Antes el privado `_Bullet`.
class PrivacyBullet extends PrivacyBlock {
  final String text;
  const PrivacyBullet(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 7, right: 10),
              child: Icon(Icons.circle, size: 6, color: context.colors.primary),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
}
