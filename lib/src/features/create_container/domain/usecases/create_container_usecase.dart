import '../repositories/create_container_repository.dart';

class CreateContainerUseCase {
  final CreateContainerRepository repository;

  CreateContainerUseCase(this.repository);

  Future<dynamic> call() async {
    await repository.fetch();
  }
}
