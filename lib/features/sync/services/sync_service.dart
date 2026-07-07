import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/storage/local_database.dart';
import '../data/datasources/sync_local_datasource.dart';
import '../domain/entities/sync_item_entity.dart';

@lazySingleton
class SyncService extends ChangeNotifier {
  final SyncLocalDataSource _localDS;
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  final LocalDatabase _localDatabase;
  final Dio _dio;

  StreamSubscription? _connSub;
  Timer? _pollingTimer;

  bool _isOnline = false;
  bool get isOnline => _isOnline;

  List<SyncItemEntity> _items = [];
  List<SyncItemEntity> get items => _items;

  SyncService(this._localDS, this._apiClient, this._tokenStorage, this._localDatabase)
      : _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)) {
    _init();
  }

  Future<void> _init() async {
    final connectivity = Connectivity();
    final initialResults = await connectivity.checkConnectivity();
    _isOnline = initialResults.any((r) => r != ConnectivityResult.none);

    _connSub = connectivity.onConnectivityChanged.listen((results) {
      _isOnline = results.any((r) => r != ConnectivityResult.none);
      notifyListeners();
      if (_isOnline) {
        _startUploads();
      }
    });

    await _refreshItems();
    
    // Polling timer for items in 'processing' state
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_isOnline) _pollProcessingItems();
    });
  }

  Future<void> _refreshItems() async {
    _items = await _localDS.getAllItems();
    notifyListeners();
  }

  /// Adds a new audio to the sync queue.
  Future<void> queueAudio({
    required String localId,
    required String audioPath,
    required int proyectoId,
    required String fechaGrabacion,
    int? duracionSegundos,
  }) async {
    final item = SyncItemEntity(
      localId: localId,
      audioPath: audioPath,
      proyectoId: proyectoId,
      fechaGrabacion: fechaGrabacion,
      duracionSegundos: duracionSegundos,
      estado: 'pending',
      progreso: 0.0,
    );
    await _localDS.insertItem(item);
    await _refreshItems();
    
    if (_isOnline) {
      _startUploads();
    }
  }

  bool _isUploading = false;

  Future<void> _startUploads() async {
    if (_isUploading) return;
    _isUploading = true;

    try {
      await _syncPendingProjects();

      while (true) {
        final pending = await _localDS.getPendingItems();
        if (pending.isEmpty) break;

        final item = pending.first;
        await _uploadItem(item);
        await _refreshItems();
      }
    } finally {
      _isUploading = false;
    }
  }

  Future<void> _syncPendingProjects() async {
    final db = await _localDatabase.database;
    final pendingProjects = await db.query('proyectos', where: 'is_synced = ?', whereArgs: [0]);
    
    for (var p in pendingProjects) {
      try {
        final int oldId = p['id'] as int;
        final String nombre = p['nombre'] as String;
        final String? direccion = p['direccion'] as String?;
        
        final data = await _apiClient.postJson(
          ApiConfig.proyectos,
          {
            'nombre': nombre,
            if (direccion != null && direccion.isNotEmpty) 'direccion': direccion,
          },
          auth: true,
        );
        
        final int newId = data['id'] as int;
        
        // Actualizar proyecto en local con su ID real y marcar como sincronizado
        await db.update(
          'proyectos',
          {'id': newId, 'is_synced': 1},
          where: 'id = ?',
          whereArgs: [oldId],
        );
        
        // Actualizar cualquier audio pendiente en sync_queue que apuntara a este proyecto offline
        await db.update(
          'sync_queue',
          {'proyecto_id': newId},
          where: 'proyecto_id = ?',
          whereArgs: [oldId],
        );
      } catch (e) {
        // Falló sincronización de este proyecto, intentar después
      }
    }
  }

  Future<void> _uploadItem(SyncItemEntity item) async {
    // Update state to uploading
    var currentItem = item.copyWith(estado: 'uploading', progreso: 0.0);
    await _localDS.updateItem(currentItem);
    await _refreshItems();

    try {
      final token = _tokenStorage.token;
      if (token == null) throw Exception('No auth token');

      final formData = FormData.fromMap({
        'proyecto_id': currentItem.proyectoId,
        'local_id': currentItem.localId,
        'fecha_grabacion': currentItem.fechaGrabacion,
        if (currentItem.duracionSegundos != null)
          'duracion_segundos': currentItem.duracionSegundos,
        'audio': await MultipartFile.fromFile(currentItem.audioPath),
      });

      final response = await _dio.post(
        ApiConfig.grabaciones,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        onSendProgress: (sent, total) {
          final progress = total > 0 ? sent / total : 0.0;
          currentItem = currentItem.copyWith(progreso: progress);
          _localDS.updateItem(currentItem).then((_) => _refreshItems());
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        final data = response.data;
        final apiId = data['id'];
        final syncState = data['estado_sincronizacion']; 
        
        if (syncState == 'listo' || syncState == 'sincronizado') {
          currentItem = currentItem.copyWith(estado: 'ready', apiId: apiId, progreso: 1.0);
        } else {
          currentItem = currentItem.copyWith(estado: 'processing', apiId: apiId, progreso: 1.0);
        }
      } else {
        currentItem = currentItem.copyWith(estado: 'error');
      }
    } catch (e) {
      currentItem = currentItem.copyWith(estado: 'error');
    }

    await _localDS.updateItem(currentItem);
  }

  Future<void> _pollProcessingItems() async {
    final processing = await _localDS.getProcessingItems();
    if (processing.isEmpty) return;

    for (var item in processing) {
      if (item.apiId == null) continue;
      try {
        final data = await _apiClient.getJson(ApiConfig.grabacion(item.apiId!), auth: true);
        final syncState = data['estado_sincronizacion'];
        if (syncState == 'listo' || syncState == 'sincronizado') {
          final updated = item.copyWith(estado: 'ready');
          await _localDS.updateItem(updated);
          await _refreshItems();
        }
      } catch (e) {
        // Ignorar errores temporales
      }
    }
  }

  Future<void> clearReadyItems() async {
    await _localDS.clearReadyItems();
    await _refreshItems();
  }

  @override
  void dispose() {
    _connSub?.cancel();
    _pollingTimer?.cancel();
    super.dispose();
  }
}
