import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:offline_first/src/features/lista_controller.dart';

import '../core/sync/event_bus_service.dart';
import '../core/sync/sync_complete.dart';
import '../data/models/contato_model.dart';
import '../data/repository/contato_repository.dart';

class ListaContatos extends StatefulWidget {
  const ListaContatos({super.key});

  @override
  State<ListaContatos> createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  late ListaController listaController;

  @override
  void initState() {
    listaController = ListaController(
      ContatoRepository(
        contatoBox: Hive.box<ContatoModel>('contacts'),
        firestore: FirebaseFirestore.instance,
      ),
    );
    listaController.getContatos();

    EventBusService().on<SyncCompletedEvent>(
      (event) {
        print('Sincronização concluída!');
        listaController.refresh();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Contatos')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<List<ContatoModel>>(
              stream: listaController.getContatosStream(),
              builder: (context, snapshot) {
                print(snapshot.connectionState.toString());
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar contatos'));
                } else {
                  final contatos = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: contatos.length,
                    itemBuilder: (context, index) {
                      final contato = contatos[index];
                      return ListTile(
                        title: Text(contato.name),
                        subtitle: Text(contato.email),
                        trailing: (contato.isSynced) ? Icon(Icons.cloud_done, color: Colors.green) : Icon(Icons.cloud_off, color: Colors.red),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final randomId = DateTime.now().millisecondsSinceEpoch.toString();
          listaController.adicionarContato(ContatoModel(id: randomId, name: randomId, email: randomId, phoneNumber: randomId));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
