import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:offline_first/src/core/connection_check/connection_check.dart';

import '../models/contato_model.dart';

class ContatoRepository {
  final Box<ContatoModel> _contatoBox;
  final FirebaseFirestore _firestore;

  ContatoRepository({required Box<ContatoModel> contatoBox, FirebaseFirestore? firestore}) : _contatoBox = contatoBox, _firestore = firestore ?? FirebaseFirestore.instance;

  // Sempre retorna dados locais (offline-first)
  Future<List<ContatoModel>> getAll() async {
    return _contatoBox.values.toList();
  }

  // Método separado para sincronizar dados remotos apenas se necessário
  Future<void> syncRemoteData() async {
    final hasConnection = await ConnectionCheck.isConnected();
    if (!hasConnection) return;

    try {
      final snapshot = await _firestore.collection('contatos').get();

      for (var doc in snapshot.docs) {
        final remoteContato = ContatoModel.fromMap(doc.data());

        // Verifica se já existe localmente para evitar duplicação
        final existsLocally = _contatoBox.values.any((local) => local.id == remoteContato.id || local.remoteId == doc.id || (local.name == remoteContato.name && local.phoneNumber == remoteContato.phoneNumber));

        if (!existsLocally) {
          // Adiciona apenas se não existir localmente
          await _contatoBox.add(
            remoteContato.copyWith(
              isSynced: true, // Marca como já sincronizado
              remoteId: doc.id, // Salva a referência do Firebase
            ),
          );
        }
      }
    } catch (e) {
      print('[Repository] Erro ao sincronizar dados remotos: $e');
    }
  }

  // Método para sincronização inicial (primeira vez que abre o app)
  Future<void> initialSync() async {
    if (_contatoBox.isEmpty && await ConnectionCheck.isConnected()) {
      await syncRemoteData();
    }
  }

  Future<ContatoModel> addContato(ContatoModel contato) async {
    await _contatoBox.add(contato);
    return contato;
  }
}
