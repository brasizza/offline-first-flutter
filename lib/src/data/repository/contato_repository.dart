import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:offline_first/src/core/connection_check/connection_check.dart';

import '../models/contato_model.dart';

class ContatoRepository {
  final Box<ContatoModel> _contatoBox;
  final FirebaseFirestore _firestore;

  ContatoRepository({required Box<ContatoModel> contatoBox, FirebaseFirestore? firestore}) : _contatoBox = contatoBox, _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ContatoModel>> getAll() async {
    final contatos = _contatoBox.values.toList();
    final hasConnection = await ConnectionCheck.isConnected();
    if (hasConnection) {
      final snapshot = await _firestore.collection('contatos').get();
      for (var doc in snapshot.docs) {
        final contato = ContatoModel.fromMap(doc.data());
        contatos.add(contato);
      }
    }
    return contatos;
  }

  Future<ContatoModel> addContato(ContatoModel contato) async {
    await _contatoBox.add(contato);
    return contato;
  }
}
