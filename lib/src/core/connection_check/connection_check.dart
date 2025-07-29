import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../sync/sync_service.dart';

class ConnectionCheck {
  final SyncService syncService;

  ConnectionCheck._internal(this.syncService);

  static ConnectionCheck? _instance;

  factory ConnectionCheck(SyncService syncService) {
    _instance ??= ConnectionCheck._internal(syncService);
    return _instance!;
  }

  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get connectionStream => _connectionController.stream;

  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    final hasConnection = !result.contains(ConnectivityResult.none);

    return hasConnection;
  }

  Future<void> init() async {
    _subscription?.cancel();
    syncService.watch();
    final result = await Connectivity().checkConnectivity();
    final hasConnection = !result.contains(ConnectivityResult.none);
    _connectionController.add(hasConnection);

    if (hasConnection) {
      syncService.sincronizarPendencias();
    }

    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      final hasConnection = !result.contains(ConnectivityResult.none);

      if (hasConnection) {
        _connectionController.add(true);
        syncService.sincronizarPendencias();
      } else {
        _connectionController.add(false);
      }
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _connectionController.close();
  }
}
