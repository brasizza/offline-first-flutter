import 'package:flutter_getit/flutter_getit.dart';

import 'presentation/cubit/{{name}}_cubit.dart';
import 'domain/usecases/{{name}}_usecase.dart';
import 'domain/repositories/{{name}}_repository.dart';
import 'data/repositories/{{name}}_repository_impl.dart';
import 'data/services/{{name}}_service.dart';
import 'presentation/{{name}}_page.dart';

class {{name.pascalCase()}}Module extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        Bind.singleton((i) => {{name.pascalCase()}}Service()),
        Bind.singleton<{{name.pascalCase()}}Repository>((i) => {{name.pascalCase()}}RepositoryImpl(i())),
        Bind.singleton((i) => {{name.pascalCase()}}UseCase(i())),
        Bind.singleton((i) => {{name.pascalCase()}}Cubit(i())),
      ];

  @override
  String get moduleRouteName => '/';

  @override
   List<FlutterGetItPageRouter> get pages => [
    FlutterGetItModuleRouter(
      name: '/',
      bindings:[], 
      pages: [
        FlutterGetItPageRouter(
          name: '/{{name}}',
          builder: (_) => const {{name.pascalCase()}}Page(),
        ),
      ],
    ),
  ];
}
