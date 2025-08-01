import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:hive_ce/hive.dart';
import 'package:offline_first/src/core/repositories/box_container_repository_firebase_impl.dart' show BoxContainerRepositoryImpl;
import 'package:offline_first/src/data/models/box_container_model.dart';

import 'repositories/box_container_repository.dart';
import 'services/box_container_service.dart';

class InitialBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
    Bind.singletonAsync(
      (i) async {
        final box = await Hive.openBox<BoxContainerModel>('boxContainers');
        return box;
      },
    ),

    Bind.singleton<BoxContainerRepository>(
      (i) => BoxContainerRepositoryImpl(
        boxContainerBox: (i()),
        firestore: FirebaseFirestore.instance,
      ),
      dependsOn: [Box<BoxContainerModel>],
    ),

    Bind.singleton<BoxContainerService>(
      (i) => BoxContainerService(
        i(),
      ),
      dependsOn: [BoxContainerRepository],
    ),
  ];
}
