import 'package:offline_first/src/data/models/box_container_model.dart';

import '../repositories/create_container_repository.dart';

class CreateContainerUseCase {
  final CreateContainerRepository repository;

  CreateContainerUseCase(this.repository);

  Future<bool> call(BoxContainerModel container) async {
    return await repository.register(container);
  }
}
