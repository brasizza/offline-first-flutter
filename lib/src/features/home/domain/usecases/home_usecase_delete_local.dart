import '../../../../data/models/box_container_model.dart';
import '../repositories/home_repository.dart';

class HomeUsecaseDeleteLocal {
  final HomeRepository repository;

  HomeUsecaseDeleteLocal(this.repository);

  Future<bool> call(BoxContainerModel container) async {
    return await repository.deleteContainer(container);
  }
}
