import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'O CONTINÚA CON',
            style: TextStyle(
              fontSize: 11,
              color: context.colors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
