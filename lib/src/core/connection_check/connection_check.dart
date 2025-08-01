import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../sync/sync_service.dart';

class ConnectionCheck {
  final SyncService syncService;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectionCheck(this.syncService);

  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    final hasConnection = !result.contains(ConnectivityResult.none);

    return hasConnection;
  }

  Future<void> startListening() async {
    _subscription?.cancel();
    final result = await Connectivity().checkConnectivity();
    final hasConnection = !result.contains(ConnectivityResult.none);
    if (hasConnection) {
      syncService.sincronizarPendencias();
    }

    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      final hasConnection = !result.contains(ConnectivityResult.none);

      if (hasConnection) {
        syncService.sincronizarPendencias();
      } else {}
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
