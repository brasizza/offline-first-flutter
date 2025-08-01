import '../../domain/repositories/create_container_repository.dart';
import '../services/create_container_service.dart';
class CreateContainerRepositoryImpl implements CreateContainerRepository {
  final CreateContainerService _service;

  CreateContainerRepositoryImpl(this._service);

  @override
  Future<void> fetch() async {
  }
}
