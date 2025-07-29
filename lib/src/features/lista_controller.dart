import 'dart:async';

import 'package:offline_first/src/data/repository/contato_repository.dart';

import '../data/models/contato_model.dart';

class ListaController {
  final ContatoRepository _contatoRepository;
  final List<ContatoModel> contatos = [];
  final StreamController<List<ContatoModel>> _contatosController = StreamController<List<ContatoModel>>.broadcast();

  ListaController(this._contatoRepository);
  void adicionarContato(ContatoModel contato) async {
    final contatoAdd = await _contatoRepository.addContato(contato);
    contatos.add(contatoAdd);
    _contatosController.sink.add(contatos);
  }

  Future<List<ContatoModel>> getContatos() async {
    contatos.clear();
    contatos.addAll((await _contatoRepository.getAll()).toSet().toList());
    _contatosController.sink.add(contatos);
    return contatos;
  }

  Stream<List<ContatoModel>> getContatosStream() {
    return _contatosController.stream;
  }

  void limparContatos() {
    contatos.clear();
  }

  Future<void> refresh() async {
    contatos.clear();
    await getContatos();
  }
}
