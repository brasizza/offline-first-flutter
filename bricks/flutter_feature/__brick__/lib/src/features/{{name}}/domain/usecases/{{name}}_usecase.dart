import '../repositories/{{name}}_repository.dart';

class {{name.pascalCase()}}UseCase {
  final {{name.pascalCase()}}Repository repository;

  {{name.pascalCase()}}UseCase(this.repository);

  Future<dynamic> call() async {
    await repository.fetch();
  }
}
