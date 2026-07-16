import 'package:flutter/material.dart';

import '../../../budget/presentation/widgets/mis_pdfs_view.dart';

/// Pestaña "Mis Cotizaciones": lista las cotizaciones/PDFs del usuario en todas
/// sus obras. El contenido vive en `MisPdfsView` (feature budget).
class MisCotizacionesTab extends StatelessWidget {
  const MisCotizacionesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: MisPdfsView());
  }
}
