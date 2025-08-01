import '../../data/models/box_container_model.dart';
import '../repositories/box_container_repository.dart';

class BoxContainerService {
  final BoxContainerRepository _boxContainerRepository;

  BoxContainerService(this._boxContainerRepository);
  Future<List<BoxContainerModel>> getAllContainers() {
    return _boxContainerRepository.getAll();
  }

  BoxContainerModel? getContainerById(String id) {
    return _boxContainerRepository.getById(id);
  }

  Future<BoxContainerModel> addContainer(BoxContainerModel container) {
    return _boxContainerRepository.addContainer(container);
  }

  Future<BoxContainerModel> updateContainer(BoxContainerModel container) {
    return _boxContainerRepository.updateContainer(container);
  }

  Future<void> deleteContainer(String id) {
    return _boxContainerRepository.deleteContainer(id);
  }

  Future<bool> initialSync() async {
    return await _boxContainerRepository.initialSync();
  }

  Future<bool> syncRemoteData() async {
    return await _boxContainerRepository.syncRemoteData();
  }

  List<BoxContainerModel> getUnsyncedContainers() {
    return _boxContainerRepository.getUnsyncedContainers();
  }

  int getActiveContainersCount() {
    return _boxContainerRepository.getActiveContainersCount();
  }

  Future<void> clearAllContainers() async {
    final containers = await _boxContainerRepository.getAll();
    for (var container in containers) {
      await _boxContainerRepository.deleteContainer(container.id);
    }
  }

  Future<void> clearUnsyncedContainers() async {
    final unsyncedContainers = _boxContainerRepository.getUnsyncedContainers();
    for (var container in unsyncedContainers) {
      await _boxContainerRepository.deleteContainer(container.id);
    }
  }

  Future<void> clearDeletedContainers() async {
    final containers = await _boxContainerRepository.getAll();
    for (var container in containers) {
      if (container.isDeleted) {
        await _boxContainerRepository.deleteContainer(container.id);
      }
    }
  }

  Future<void> clearAll() async {
    await clearAllContainers();
    await clearUnsyncedContainers();
    await clearDeletedContainers();
  }
}
