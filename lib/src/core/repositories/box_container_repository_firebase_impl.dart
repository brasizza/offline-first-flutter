import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:offline_first/src/core/connection_check/connection_check.dart';
import 'package:offline_first/src/data/models/box_container_model.dart';

import 'box_container_repository.dart';

class BoxContainerRepositoryImpl implements BoxContainerRepository {
  final Box<BoxContainerModel> _boxContainerBox;
  final FirebaseFirestore _firestore;

  BoxContainerRepositoryImpl({
    required Box<BoxContainerModel> boxContainerBox,
    FirebaseFirestore? firestore,
  }) : _boxContainerBox = boxContainerBox,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<BoxContainerModel>> getAll() async {
    return _boxContainerBox.values.where((container) => !container.isDeleted).toList();
  }

  @override
  BoxContainerModel? getById(String id) {
    try {
      return _boxContainerBox.values.where((container) => container.id == id && !container.isDeleted).first;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<BoxContainerModel> addContainer(BoxContainerModel container) async {
    await _boxContainerBox.add(container);
    log('[BoxContainerRepository] Container adicionado: ${container.name}');
    return container;
  }

  @override
  Future<BoxContainerModel> updateContainer(BoxContainerModel container) async {
    final index = _boxContainerBox.values.toList().indexWhere((c) => c.id == container.id);

    if (index != -1) {
      final updatedContainer = container.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false, // Marca para sincronização
      );
      await _boxContainerBox.putAt(index, updatedContainer);
      log('[BoxContainerRepository] Container atualizado: ${updatedContainer.name}');
      return updatedContainer;
    }

    throw Exception('Container não encontrado para atualização');
  }

  @override
  Future<void> deleteContainer(String id) async {
    final index = _boxContainerBox.values.toList().indexWhere((c) => c.id == id);

    if (index != -1) {
      final container = _boxContainerBox.getAt(index)!;
      final deletedContainer = container.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
        isSynced: false, // Marca para sincronização
      );
      await _boxContainerBox.putAt(index, deletedContainer);
      log('[BoxContainerRepository] Container marcado como deletado: ${container.name}');
    } else {
      throw Exception('Container não encontrado para exclusão');
    }
  }

  @override
  Future<bool> initialSync() async {
    if (_boxContainerBox.isEmpty && await ConnectionCheck.isConnected()) {
      log('[BoxContainerRepository] Iniciando sincronização inicial...');
      return await syncRemoteData();
    }
    return false;
  }

  @override
  Future<bool> syncRemoteData() async {
    final hasConnection = await ConnectionCheck.isConnected();
    if (!hasConnection) {
      log('[BoxContainerRepository] Sem conexão - pulando sincronização remota');
      return false;
    }

    try {
      log('[BoxContainerRepository] Iniciando sincronização de dados remotos...');
      final snapshot = await _firestore.collection('box_containers').get();

      int newContainers = 0;
      for (var doc in snapshot.docs) {
        final remoteContainer = BoxContainerModel.fromMap(doc.data());

        // Verifica se já existe localmente para evitar duplicação
        final existsLocally = _boxContainerBox.values.any(
          (local) => local.id == remoteContainer.id || local.remoteId == doc.id || (local.name == remoteContainer.name && local.responsiblePerson == remoteContainer.responsiblePerson && local.createdAt == remoteContainer.createdAt),
        );

        if (!existsLocally) {
          await _boxContainerBox.add(
            remoteContainer.copyWith(
              isSynced: true,
              remoteId: doc.id,
            ),
          );
          newContainers++;
        }
      }

      log('[BoxContainerRepository] Sincronização concluída. $newContainers novos containers adicionados');
      return true;
    } catch (e) {
      log('[BoxContainerRepository] Erro ao sincronizar dados remotos: $e');
      rethrow; // Re-lança para permitir tratamento pela camada superior
    }
  }

  @override
  List<BoxContainerModel> getUnsyncedContainers() {
    return _boxContainerBox.values.where((container) => !container.isSynced).toList();
  }

  @override
  int getActiveContainersCount() {
    return _boxContainerBox.values.where((container) => !container.isDeleted).length;
  }

  /// Limpa containers deletados permanentemente (usar com cuidado)
  Future<int> clearDeletedContainers() async {
    final deletedContainers = _boxContainerBox.values.where((container) => container.isDeleted).toList();

    for (final container in deletedContainers) {
      await container.delete();
    }

    log('[BoxContainerRepository] ${deletedContainers.length} containers deletados permanentemente');
    return deletedContainers.length;
  }

  /// Força sincronização de um container específico
  Future<void> forceSyncContainer(String id) async {
    final container = getById(id);
    if (container != null && !container.isSynced) {
      // Este método seria chamado pelo SyncService
      log('[BoxContainerRepository] Container $id marcado para sincronização forçada');
    }
  }
}
