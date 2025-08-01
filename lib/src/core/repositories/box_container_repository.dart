import '../../data/models/box_container_model.dart';

abstract class BoxContainerRepository {
  Future<List<BoxContainerModel>> getAll();

  BoxContainerModel? getById(String id);

  Future<BoxContainerModel> addContainer(BoxContainerModel container);
  Future<BoxContainerModel> addContainerRemote(BoxContainerModel container);

  Future<BoxContainerModel> updateContainer(BoxContainerModel container);

  Future<void> deleteContainer(String id);
  Future<void> deleteContainerRemote(String id);

  Future<bool> initialSync();

  Future<bool> syncRemoteData();

  List<BoxContainerModel> getUnsyncedContainers();

  int getActiveContainersCount();
}
