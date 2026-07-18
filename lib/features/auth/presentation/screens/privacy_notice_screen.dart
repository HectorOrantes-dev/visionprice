import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../widgets/privacy_notice_content.dart';

/// Aviso de Privacidad Integral. Se muestra como pantalla completa desde el
/// enlace ubicado en la vista de login (y reutilizable desde otras vistas).
class PrivacyNoticeScreen extends StatelessWidget {
  const PrivacyNoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'Aviso de Privacidad',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: privacyNoticeBlocks.map((b) => b.build(context)).toList(),
          ),
        ),
      ),
    );
  }
}
