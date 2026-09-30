import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../../connection_check/connection_check.dart';
import '../../sync/sync_service.dart';
import '../theme/status_colors.dart';

/// Pílula global com o estado da conexão: Online, Offline ou Sincronizando.
class SyncStatusPill extends StatelessWidget {
  const SyncStatusPill({super.key});

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

        final (label, fg, bg, key) = switch ((online, syncing)) {
          (true, true) => ('Sincronizando', colors.pending, colors.pendingContainer, 'syncing'),
          (true, false) => ('Online', colors.synced, colors.syncedContainer, 'online'),
          (false, _) => ('Offline', colors.offline, colors.offlineContainer, 'offline'),
        };

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.fromLTRB(10, 7, 14, 7),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: fg.withValues(alpha: 0.25)),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(sizeFactor: animation, axis: Axis.horizontal, child: child),
            ),
            child: Row(
              key: ValueKey(key),
              mainAxisSize: MainAxisSize.min,
              children: [
                switch (key) {
                  'syncing' => SizedBox.square(
                    dimension: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                  ),
                  'offline' => Icon(Icons.cloud_off_rounded, size: 14, color: fg),
                  _ => _PulsingDot(color: fg),
                },
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 14,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 6 + 8 * t,
                height: 6 + 8 * t,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.35 * (1 - t)),
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
              ),
            ],
          );
        },
      ),
    );
  }
}
