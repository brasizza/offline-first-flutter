import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:hive_ce/hive.dart';
import 'package:offline_first/src/core/repositories/box_container_repository_firebase_impl.dart' show BoxContainerRepositoryImpl;
import 'package:offline_first/src/data/models/box_container_model.dart';

import 'connection_check/connection_check.dart';
import 'repositories/box_container_repository.dart';
import 'services/box_container_service.dart';
import 'sync/sync_service.dart';

class InitialBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
    Bind.singletonAsync(
      (i) async {
        final box = await Hive.openBox<BoxContainerModel>('boxContainers');
        return box;
      },
    ),
    Bind.singleton((i) => EventBus()),
    Bind.lazySingleton((i) => FirebaseFirestore.instance),
    Bind.singleton<BoxContainerRepository>(
      (i) => BoxContainerRepositoryImpl(
        boxContainerBox: (i()),
        firestore: i(),
      ),
      dependsOn: [Box<BoxContainerModel>],
    ),

    Bind.singleton<BoxContainerService>(
      (i) => BoxContainerService(
        i(),
      ),
      dependsOn: [BoxContainerRepository],
    ),
    Bind.lazySingleton(
      (i) => SyncService(
        box: i<Box<BoxContainerModel>>(),
        boxContainerRepository: i<BoxContainerRepository>(),
        eventBus: i(),
      ),
    ),

    Bind.lazySingleton((i) => ConnectionCheck(i<SyncService>())),
  ];
}
