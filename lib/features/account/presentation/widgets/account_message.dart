import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Mensaje centrado para estados vacío/error. Antes el privado `_Message`.
class AccountMessage extends StatelessWidget {
  final String text;
  const AccountMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.textSecondary),
        ),
      ),
    );
  }
}
