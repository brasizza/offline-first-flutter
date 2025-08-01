import 'package:event_bus/event_bus.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../../core/sync/sync_complete.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/home_usecase_delete_local.dart';
import 'domain/usecases/home_usecase_list_local.dart';
import 'presentation/cubit/home_cubit.dart';
import 'presentation/home_page.dart';

class HomeModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
    Bind.singleton<HomeRepository>((i) => HomeRepositoryImpl(i())),
  ];

  @override
  String get moduleRouteName => '/home';

  @override
  List<FlutterGetItPageRouter> get pages => [
    FlutterGetItModuleRouter(
      name: '/initial',
      bindings: [],
      pages: [
        FlutterGetItPageRouter(
          bindings: [
            Bind.singleton((i) => HomeUsecaseListLocal(i())),
            Bind.singleton((i) => HomeUsecaseDeleteLocal(i())),
            Bind.singleton((i) => HomeCubit(i(), i())),
          ],
          name: '/start',
          builder: (_) => const HomePage(),
        ),
      ],
    ),
  ];
  @override
  void onInit(Injector i) {
    super.onInit(i);
    i<HomeCubit>().load();
    i<EventBus>().on<SyncCompletedEvent>().listen((event) {
      i<HomeCubit>().load();
    });
  }
}
