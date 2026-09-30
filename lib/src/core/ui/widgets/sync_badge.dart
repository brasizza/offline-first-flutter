import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../../connection_check/connection_check.dart';
import '../../sync/sync_service.dart';
import '../theme/status_colors.dart';

/// Badge de sincronização de um box: Sincronizado, Pendente/Sincronizando ou Somente local.
class SyncBadge extends StatelessWidget {
  final bool isSynced;
  final bool compact;

  const SyncBadge({super.key, required this.isSynced, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final connection = context.get<ConnectionCheck>();
    final sync = context.get<SyncService>();
    final colors = context.statusColors;

    return ListenableBuilder(
      listenable: Listenable.merge([connection.isOnline, sync.isSyncing]),
      builder: (context, _) {
        final online = connection.isOnline.value;
        final syncing = sync.isSyncing.value;

        final (label, icon, fg, bg) = switch ((isSynced, online)) {
          (true, _) => ('Sincronizado', Icons.cloud_done_rounded, colors.synced, colors.syncedContainer),
          (false, true) => (
            syncing ? 'Enviando' : 'Pendente',
            Icons.cloud_upload_rounded,
            colors.pending,
            colors.pendingContainer,
          ),
          (false, false) => ('Somente local', Icons.cloud_off_rounded, colors.offline, colors.offlineContainer),
        };

        final iconWidget = !isSynced && online && syncing ? SizedBox.square(dimension: 12, child: CircularProgressIndicator(strokeWidth: 1.8, color: fg)) : Icon(icon, size: 14, color: fg);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: 5),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(100),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Row(
              key: ValueKey(label),
              mainAxisSize: MainAxisSize.min,
              children: [
                iconWidget,
                if (!compact) ...[
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
