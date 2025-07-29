import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:offline_first/src/data/repository/contato_repository.dart';

import 'firebase_options.dart';
import 'src/core/connection_check/connection_check.dart';
import 'src/core/sync/sync_service.dart';
import 'src/data/models/contato_model.dart';
import 'src/features/lista_contatos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await initHive();

  final syncService = SyncService(
    box: Hive.box<ContatoModel>('contacts'),
    firestore: FirebaseFirestore.instance,
  );
  final checkConnection = ConnectionCheck(
    syncService,
  );
  await checkConnection.init();

  runApp(const MyApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ContatoModelAdapter());
  await Hive.openBox<ContatoModel>('contacts');
  final repository = ContatoRepository(contatoBox: Hive.box<ContatoModel>('contacts'));
  await repository.initialSync();
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const ListaContatos(),
    );
  }
}
