import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:offline_first/src/core/connection_check/connection_check.dart';
import 'package:offline_first/src/data/models/contato_model.dart';

import 'event_bus_service.dart';
import 'sync_complete.dart';

class SyncService {
  static SyncService? _instance;
  final Box<ContatoModel> box;
  final FirebaseFirestore firestore;

  // Construtor privado
  SyncService._internal(this.box, this.firestore);

  // Factory que cria ou retorna o singleton
  factory SyncService({required Box<ContatoModel> box, required FirebaseFirestore firestore}) {
    return _instance ??= SyncService._internal(box, firestore);
  }

  void watch() {
    box.watch().listen((event) async {
      final hasConnection = await ConnectionCheck.isConnected();
      if (event.deleted || event.value.isSynced) {
        log('[Sync] Contato deletado ou já sincronizado: ${event.value.toString()}');
        return;
      }
      log('[Sync] Novo contato adicionado: ${event.value.toString()}');
      if (hasConnection) {
        await sincronizarContato(event.value);
      } else {
        log('[Sync] Sem conexão, aguardando sincronização posterior');
      }
    });
  }

  bool _isSyncing = false;

  Future<void> sincronizarContato(ContatoModel contato) async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await firestore.collection('contatos').add(contato.copyWith(isSynced: true).toMap());
      await contato.delete();
      log('[Sync] Contato sincronizado: ${contato.toString()}');
    } catch (e) {
      log('[Sync] Erro ao sincronizar contato: $e');
    } finally {
      EventBusService().fire(SyncCompletedEvent());
      _isSyncing = false;
    }
  }

  Future<void> sincronizarPendencias() async {
    var hasUpdate = false;
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final pendentes = box.values.where((e) => !e.isSynced).toList();
      if (pendentes.isNotEmpty) {
        hasUpdate = true;
      }
      for (final item in pendentes) {
        await firestore.collection('contatos').add(item.copyWith(isSynced: true).toMap());
        await item.delete();
      }
      log('[Sync] Finalizado com sucesso');
    } catch (e) {
      log('[Sync] Erro ao sincronizar: $e');
    } finally {
      if (hasUpdate) {
        EventBusService().fire(SyncCompletedEvent());
      }
      _isSyncing = false;
    }
  }
}
