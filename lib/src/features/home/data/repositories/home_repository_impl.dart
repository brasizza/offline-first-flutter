import 'package:offline_first/src/core/services/box_container_service.dart';

import '../../../../data/models/box_container_model.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final BoxContainerService _service;

  HomeRepositoryImpl(this._service);

  @override
  Future<List<BoxContainerModel>?> fetchAll() async {
    return await _service.getAllContainers();
  }

  @override
  Future<bool> deleteContainer(BoxContainerModel container) async {
    await _service.deleteContainer(container.id);
    return true;
  }
}
