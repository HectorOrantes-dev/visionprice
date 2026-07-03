import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Mensaje centrado para estados vacío/error. Antes el privado `_Message`.
class NotifMessage extends StatelessWidget {
  final String text;
  const NotifMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
