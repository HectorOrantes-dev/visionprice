import 'package:intl/intl.dart';

/// Formateadores de moneda para México (MXN)
extension CurrencyX on double {
  /// Formatea como moneda MXN: $12,450.00
  String get toMXN {
    final formatter = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  /// Formato compacto: $12.4K o $1.2M
  String get toMXNCompact {
    if (this >= 1000000) {
      return '\$${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '\$${(this / 1000).toStringAsFixed(1)}K';
    }
    return toMXN;
  }

  /// Formato porcentaje: 12.5%
  String get toPercent => '${toStringAsFixed(1)}%';

  /// m² con dos decimales
  String get toM2 => '${toStringAsFixed(2)} m²';
}

extension IntX on int {
  String get toMXN => toDouble().toMXN;
}
