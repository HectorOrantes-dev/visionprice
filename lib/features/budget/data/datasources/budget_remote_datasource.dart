import 'package:injectable/injectable.dart';
import '../../domain/entities/estimate.dart';
import '../models/estimate_model.dart';

/// Contrato del datasource remoto de presupuestos.
abstract interface class BudgetRemoteDatasource {
  Future<EstimateModel> getEstimate(String projectId);
  Future<String> exportToPdf(Estimate estimate);
  Future<EstimateModel> updateContingency(String estimateId, double percent);
}

/// Implementación del datasource — actualmente usa datos mock.
/// Sustituir el cuerpo de cada método cuando el backend esté disponible.
@Injectable(as: BudgetRemoteDatasource)
class BudgetRemoteDatasourceImpl implements BudgetRemoteDatasource {
  const BudgetRemoteDatasourceImpl();

  @override
  Future<EstimateModel> getEstimate(String projectId) async {
    // TODO: reemplazar con llamada Dio/Retrofit al endpoint real
    await Future.delayed(const Duration(milliseconds: 800));
    return EstimateModel(
      id: 'est_$projectId',
      projectId: projectId,
      projectName: 'Proyecto Demo',
      contingencyPercent: 10.0,
      laborCost: 8500.0,
      extrasAmount: 1200.0,
      generatedAt: DateTime.now(),
      materialLines: const [],
    );
  }

  @override
  Future<String> exportToPdf(Estimate estimate) async {
    // TODO: integrar generación real con package:pdf
    await Future.delayed(const Duration(seconds: 2));
    return '/storage/emulated/0/Downloads/presupuesto_${estimate.id}.pdf';
  }

  @override
  Future<EstimateModel> updateContingency(
      String estimateId, double percent) async {
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError('updateContingency pendiente de implementar');
  }
}
