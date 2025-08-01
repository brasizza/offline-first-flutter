import '../../../../data/models/box_container_model.dart';

abstract class HomeRepository {
  Future<List<BoxContainerModel>?> fetchAll();

  Future<bool> deleteContainer(BoxContainerModel container);
}
