//  final syncService = SyncService(
//     box: Hive.box<ContatoModel>('contacts'),
//     firestore: FirebaseFirestore.instance,
//   );
//   final checkConnection = ConnectionCheck(
//     syncService,
//   );
//   await checkConnection.init();

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:offline_first/src/core/initial_bindings.dart';
import 'package:offline_first/src/features/create_container/create_container_module.dart';
import 'package:offline_first/src/features/home/home_module.dart';

import 'features/splash/splash_module.dart';

class StarterApp extends StatelessWidget {
  const StarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: InitialBindings(),
      modules: [
        SplashModule(),
        HomeModule(),
        CreateContainerModule(),
      ],
      builder: (context, routes, isReady) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cadastro de containers',
          initialRoute: '/splash',
          themeMode: ThemeMode.system, // ou ThemeMode.light / dark
          routes: routes,
          builder: (context, child) => switch (isReady) {
            true => child ?? const SizedBox.shrink(),
            false => const Material(
              child: Center(child: CircularProgressIndicator()),
            ),
          },
        );
      },
    );
  }
}
