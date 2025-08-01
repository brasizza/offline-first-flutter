import 'package:flutter_getit/flutter_getit.dart';
import 'package:offline_first/src/core/connection_check/connection_check.dart';
import 'package:offline_first/src/core/sync/sync_service.dart';

import 'data/repositories/splash_repository_impl.dart';
import 'domain/repositories/splash_repository.dart';
import 'domain/usecases/splash_usecase.dart';
import 'presentation/cubit/splash_cubit.dart';
import 'presentation/splash_page.dart';

class SplashModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
    Bind.singleton<SplashRepository>((i) => SplashRepositoryImpl(i())),
  ];

  @override
  String get moduleRouteName => '/';

  @override
  List<FlutterGetItPageRouter> get pages => [
    FlutterGetItModuleRouter(
      name: '/',
      pages: [
        FlutterGetItPageRouter(
          bindings: [
            Bind.singleton((i) => SplashUseCase(i(), i())),
            Bind.singleton((i) => SplashCubit(i())),
          ],
          name: '/splash',
          builder: (_) => const SplashPage(),
        ),
      ],
    ),
  ];

  @override
  void onInit(Injector i) {
    super.onInit(i);
    i<ConnectionCheck>().startListening();
    i<SyncService>().startSync();
    i<SplashCubit>().load();
  }
}
