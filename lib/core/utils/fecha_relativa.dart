/// Formatea una fecha ISO como texto relativo corto para la "Actividad
/// reciente": `Hoy · 11:42 a.m.`, `Ayer · 6:15 p.m.`, `Lun 21 jul · 9:03 a.m.`
///
/// Los nombres de día/mes se arman a mano (igual que en `CotizacionPdfCard`)
/// para NO depender de `initializeDateFormatting` de intl.
String fechaRelativaActividad(String isoFecha) {
  final f = DateTime.tryParse(isoFecha)?.toLocal();
  if (f == null) return isoFecha;

  final ahora = DateTime.now();
  final hoy = DateTime(ahora.year, ahora.month, ahora.day);
  final dia = DateTime(f.year, f.month, f.day);
  final diffDias = hoy.difference(dia).inDays;

  // Si el back-end mandó solo la fecha (sin hora), no inventamos "12:00 a.m.".
  final tieneHora = f.hour != 0 || f.minute != 0;
  final hora = tieneHora ? ' · ${_hora12(f)}' : '';

  if (diffDias == 0) return 'Hoy$hora';
  if (diffDias == 1) return 'Ayer$hora';
  return '${_diaSemana(f.weekday)} ${f.day} ${_mes(f.month)}$hora';
}

String _hora12(DateTime f) {
  final sufijo = f.hour < 12 ? 'a.m.' : 'p.m.';
  var h = f.hour % 12;
  if (h == 0) h = 12;
  final m = f.minute.toString().padLeft(2, '0');
  return '$h:$m $sufijo';
}

String _diaSemana(int weekday) => const [
      'Lun',
      'Mar',
      'Mié',
      'Jue',
      'Vie',
      'Sáb',
      'Dom',
    ][weekday - 1];

String _mes(int month) => const [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ][month - 1];
