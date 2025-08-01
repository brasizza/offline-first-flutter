import 'package:flutter_getit/flutter_getit.dart';

import 'data/repositories/create_container_repository_impl.dart';
import 'data/services/create_container_service.dart';
import 'domain/repositories/create_container_repository.dart';
import 'domain/usecases/create_container_usecase.dart';
import 'presentation/create_container_page.dart';
import 'presentation/cubit/create_container_cubit.dart';

class CreateContainerModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
    Bind.singleton((i) => CreateContainerService()),
    Bind.singleton<CreateContainerRepository>((i) => CreateContainerRepositoryImpl(i())),
    Bind.singleton((i) => CreateContainerUseCase(i())),
    Bind.singleton((i) => CreateContainerCubit(i())),
  ];

  @override
  String get moduleRouteName => '/container';

  @override
  List<FlutterGetItPageRouter> get pages => [
    FlutterGetItModuleRouter(
      name: '/',
      bindings: [],
      pages: [
        FlutterGetItPageRouter(
          name: '/create',
          builder: (_) => const CreateContainerPage(),
        ),
      ],
    ),
  ];
}
