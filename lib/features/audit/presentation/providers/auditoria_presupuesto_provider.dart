import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/auditoria_resultado_entity.dart';
import 'auditoria_providers.dart';

part 'auditoria_presupuesto_provider.g.dart';

/// Auditoría de precios de UN presupuesto/cotización (`presupuestoId` =
/// `CotizacionEntity.id`, mismo id en ambos back-ends).
@riverpod
Future<AuditoriaResultadoEntity> auditoriaPresupuesto(
  Ref ref,
  int presupuestoId,
) {
  return ref.read(auditarPresupuestoUseCaseProvider)(presupuestoId);
}
