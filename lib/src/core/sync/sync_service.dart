import 'dart:developer';

import 'package:event_bus/event_bus.dart';
import 'package:hive_ce/hive.dart';
import 'package:offline_first/src/core/connection_check/connection_check.dart';

import '../../data/models/box_container_model.dart';
import '../repositories/box_container_repository.dart';
import 'sync_complete.dart';

class SyncService {
  final Box<BoxContainerModel> box;
  final BoxContainerRepository boxContainerRepository;
  final EventBus eventBus;

  SyncService({required this.box, required this.boxContainerRepository, required this.eventBus});

  void watch() {
    box.watch().listen((event) async {
      final hasConnection = await ConnectionCheck.isConnected();
      if (event.deleted || event.value.isSynced) {
        log('[Sync] Container deletado ou já sincronizado: ${event.value.toString()}');
        return;
      }
      log('[Sync] Novo container adicionado: ${event.value.toString()}');
      if (hasConnection) {
        await sincronizarPendencias();
      } else {
        log('[Sync] Sem conexão, aguardando sincronização posterior');
      }
    });
  }

  bool _isSyncing = false;

  Future<void> sincronizarPendencias() async {
    var hasUpdate = false;
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final pendentes = box.values.where((e) => !e.isSynced).toList();
      if (pendentes.isNotEmpty) {
        hasUpdate = true;
      }

      for (final container in pendentes) {
        if (container.isDeleted) {
          final index = box.values.toList().indexWhere((c) => c.key == container.key);
          if (index != -1) {
            try {
              await boxContainerRepository.deleteContainerRemote(container.id);
              await box.deleteAt(index);
              log('[Sync] Container deletado remotamente: ${container.remoteId}');
              log('[Sync] Container deletado localmente: ${container.toString()}');
            } catch (e) {
              log('[Sync] Erro ao deletar container remotamente: $e');
            }
          }
          continue;
        }
        log('[Sync] Sincronizando container: ${container.toString()}');
        if (container.remoteId != null) {
          try {
            final newContainer = await boxContainerRepository.addContainerRemote(container.copyWith(isSynced: true));
            final index = box.values.toList().indexWhere((c) => c.key == container.key);
            if (index != -1) {
              await box.putAt(
                index,
                newContainer.copyWith(
                  isSynced: true,
                  updatedAt: DateTime.now(),
                ),
              );
            }
          } catch (e) {
            log('[Sync] Erro ao sincronizar container: $e');
          }
        } else {
          try {
            final newContainer = await boxContainerRepository.addContainerRemote(container.copyWith(isSynced: true, updatedAt: DateTime.now()));
            final index = box.values.toList().indexWhere((c) => c.key == container.key);
            if (index != -1) {
              await box.putAt(
                index,
                newContainer.copyWith(isSynced: true, remoteId: newContainer.remoteId ?? '', updatedAt: DateTime.now(), createdAt: DateTime.now()),
              );
            }
          } catch (e) {
            log('[Sync] Erro ao sincronizar container: $e');
          }
        }
      }

      log('[Sync] Finalizado com sucesso');
    } catch (e) {
      log('[Sync] Erro ao sincronizar: $e');
    } finally {
      if (hasUpdate) {
        eventBus.fire(SyncCompletedEvent());
      }
      _isSyncing = false;
    }
  }

  void startSync() {
    watch();
    sincronizarPendencias();
    log('[Sync] Serviço de sincronização iniciado');
  }
}
