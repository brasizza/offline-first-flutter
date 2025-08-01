import 'package:offline_first/src/core/services/box_container_service.dart';

import '../../domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final BoxContainerService _service;

  SplashRepositoryImpl(this._service);

  @override
  Future<bool> fetch() async {
    return await _service.initialSync();
  }
}
