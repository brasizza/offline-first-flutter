import '../../../../data/models/box_container_model.dart';
import '../repositories/home_repository.dart';

class HomeUsecaseListLocal {
  final HomeRepository repository;

  HomeUsecaseListLocal(this.repository);

  Future<List<BoxContainerModel>?> call() async {
    return await repository.fetchAll();
  }
}
