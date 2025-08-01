import 'package:offline_first/src/core/repositories/box_container_repository.dart';

import '../repositories/splash_repository.dart';

class SplashUseCase {
  final SplashRepository repository;
  final BoxContainerRepository boxContainerRepository;

  SplashUseCase(this.repository, this.boxContainerRepository);

  Future<bool> call() async {
    return await repository.fetch();
  }
}
