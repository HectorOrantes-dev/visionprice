import 'package:flutter/material.dart';

/// Botón primario de ancho completo con indicador de carga, usado en el flujo
/// de recuperación de contraseña. Antes el privado `_PrimaryButton`.
class PrimaryButton extends StatelessWidget {
  final bool loading;
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}
