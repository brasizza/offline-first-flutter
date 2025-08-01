import 'package:offline_first/src/core/services/box_container_service.dart';

import '../../../../data/models/box_container_model.dart';
import '../../domain/repositories/create_container_repository.dart';

class CreateContainerRepositoryImpl implements CreateContainerRepository {
  final BoxContainerService _service;

  CreateContainerRepositoryImpl(this._service);

  @override
  Future<bool> register(BoxContainerModel container) async {
    try {
      if (_service.getContainerById(container.id) != null) {
        await _service.updateContainer(container);
        return true;
      }
      await _service.addContainer(container);
      return true;
    } catch (e) {
      // Handle error appropriately, e.g., log it or rethrow
      return false;
    }
  }
}
