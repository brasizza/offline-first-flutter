import '../../domain/repositories/{{name}}_repository.dart';
import '../services/{{name}}_service.dart';
class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  final {{name.pascalCase()}}Service _service;

  {{name.pascalCase()}}RepositoryImpl(this._service);

  @override
  Future<void> fetch() async {
  }
}
