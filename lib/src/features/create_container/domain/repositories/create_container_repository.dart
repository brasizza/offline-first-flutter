import 'package:offline_first/src/data/models/box_container_model.dart';

abstract class CreateContainerRepository {
  Future<bool> register(BoxContainerModel container);
}
