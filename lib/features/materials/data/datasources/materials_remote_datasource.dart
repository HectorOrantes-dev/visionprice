import 'package:injectable/injectable.dart';
import '../../domain/entities/material_item.dart';
import '../models/material_item_model.dart';

/// Contrato del datasource remoto de materiales.
abstract interface class MaterialsRemoteDatasource {
  Future<List<MaterialItemModel>> getMaterials(String projectId);
  Future<MaterialItemModel> updateWastePercent(
      String materialId, double percent);
  Future<MaterialItemModel> selectSupplier(String materialId, int index);
}

/// Implementación del datasource con datos mock.
@Injectable(as: MaterialsRemoteDatasource)
class MaterialsRemoteDatasourceImpl implements MaterialsRemoteDatasource {
  const MaterialsRemoteDatasourceImpl();

  @override
  Future<List<MaterialItemModel>> getMaterials(String projectId) async {
    // TODO: reemplazar con llamada Retrofit real
    await Future.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();
    return [
      MaterialItemModel(
        id: 'mat_001',
        name: 'Azulejo Porcelánico 60×60',
        unit: 'm²',
        category: 'ceramic',
        wastePercent: 10.0,
        quantityNeeded: 18.5,
        prices: [
          SupplierPriceModel(
            supplier: 'Home Depot',
            pricePerUnit: 485.0,
            fetchedAt: now,
            isRealTime: true,
          ),
          SupplierPriceModel(
            supplier: 'Sodimac',
            pricePerUnit: 460.0,
            fetchedAt: now.subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      MaterialItemModel(
        id: 'mat_002',
        name: 'Adhesivo Cementoso Flex',
        unit: 'saco 25kg',
        category: 'cement',
        wastePercent: 5.0,
        quantityNeeded: 5.0,
        prices: [
          SupplierPriceModel(
            supplier: 'Construrama',
            pricePerUnit: 320.0,
            fetchedAt: now,
            isRealTime: false,
          ),
        ],
      ),
    ];
  }

  @override
  Future<MaterialItemModel> updateWastePercent(
      String materialId, double percent) async {
    await Future.delayed(const Duration(milliseconds: 200));
    throw UnimplementedError('updateWastePercent pendiente de implementar');
  }

  @override
  Future<MaterialItemModel> selectSupplier(String materialId, int index) async {
    await Future.delayed(const Duration(milliseconds: 200));
    throw UnimplementedError('selectSupplier pendiente de implementar');
  }
}
