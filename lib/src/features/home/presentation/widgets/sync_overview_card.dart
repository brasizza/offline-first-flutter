import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../core/connection_check/connection_check.dart';
import '../../../../core/sync/sync_service.dart';
import '../../../../core/ui/formatters.dart';
import '../../../../core/ui/theme/app_theme.dart';
import '../../../../data/models/box_container_model.dart';

/// Card de destaque da Home com o resumo dos dados locais e do sincronismo.
class SyncOverviewCard extends StatefulWidget {
  final int boxCount;
  final int itemCount;
  final Future<void> Function() onSyncNow;

  const SyncOverviewCard({
    super.key,
    required this.boxCount,
    required this.itemCount,
    required this.onSyncNow,
  });

  @override
  State<SyncOverviewCard> createState() => _SyncOverviewCardState();
}

class _SyncOverviewCardState extends State<SyncOverviewCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Atualiza o "há X min" periodicamente.
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = context.get<Box<BoxContainerModel>>();
    final sync = context.get<SyncService>();
    final connection = context.get<ConnectionCheck>();
    final text = Theme.of(context).textTheme;
    final muted = Colors.white.withValues(alpha: 0.72);

    return ValueListenableBuilder<Box<BoxContainerModel>>(
      valueListenable: box.listenable(),
      builder: (context, box, _) {
        final pending = box.values.where((c) => !c.isSynced).length;

        return ListenableBuilder(
          listenable: Listenable.merge([sync.isSyncing, sync.lastSyncAt, connection.isOnline]),
          builder: (context, _) {
            final syncing = sync.isSyncing.value;
            final online = connection.isOnline.value;
            final lastSync = sync.lastSyncAt.value;

            final headline = switch ((syncing, online, pending)) {
              (true, _, _) => 'Enviando alterações…',
              (_, _, 0) => 'Tudo sincronizado',
              (_, false, _) => 'Trabalhando offline',
              _ => plural(pending, 'alteração pendente', 'alterações pendentes'),
            };

            final footer = lastSync != null
                ? 'Última sincronização ${relativeTime(lastSync)}'
                : pending == 0
                ? 'Dados em dia com a nuvem'
                : online
                ? 'Aguardando sincronização'
                : 'Será enviado quando voltar a conexão';

            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: AppTheme.brandGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.seed.withValues(alpha: 0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: -40,
                    right: -30,
                    child: _Circle(size: 150, alpha: 0.10),
                  ),
                  const Positioned(
                    bottom: -60,
                    left: 40,
                    child: _Circle(size: 140, alpha: 0.06),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: _SpinningIcon(
                                spinning: syncing,
                                icon: online ? Icons.cloud_sync_rounded : Icons.cloud_off_rounded,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sincronização', style: text.labelMedium?.copyWith(color: muted)),
                                  const SizedBox(height: 2),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: Text(
                                      headline,
                                      key: ValueKey(headline),
                                      style: text.titleMedium?.copyWith(color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _Stat(value: widget.boxCount, label: 'Boxes'),
                            const _StatDivider(),
                            _Stat(value: widget.itemCount, label: 'Itens'),
                            const _StatDivider(),
                            _Stat(value: pending, label: 'Pendentes', highlight: pending > 0),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.history_rounded, size: 16, color: muted),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                footer,
                                maxLines: 2,
                                style: text.bodySmall?.copyWith(color: muted, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: syncing ? null : widget.onSyncNow,
                              icon: _SpinningIcon(spinning: syncing, icon: Icons.sync_rounded, size: 18, color: AppTheme.seed),
                              label: const Text('Sincronizar'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.seed,
                                disabledBackgroundColor: Colors.white.withValues(alpha: 0.7),
                                disabledForegroundColor: AppTheme.seed,
                                minimumSize: const Size(0, 42),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: const StadiumBorder(),
                                textStyle: text.labelLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final int value;
  final String label;
  final bool highlight;

  const _Stat({required this.value, required this.label, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.toDouble()),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Text(
              v.round().toString(),
              style: text.headlineSmall?.copyWith(
                color: highlight ? const Color(0xFFFDE68A) : Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: text.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.72))),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.18));
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double alpha;
  const _Circle({required this.size, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}

class _SpinningIcon extends StatefulWidget {
  final bool spinning;
  final IconData icon;
  final double size;
  final Color color;

  const _SpinningIcon({
    required this.spinning,
    required this.icon,
    this.size = 22,
    this.color = Colors.white,
  });

  @override
  State<_SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<_SpinningIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.spinning) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant _SpinningIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spinning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.spinning && _controller.isAnimating) {
      _controller.animateTo(1).then((_) => _controller.reset());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      // Ícone de sync gira no sentido horário invertido para parecer "atualizando".
      turns: ReverseAnimation(_controller),
      child: Icon(widget.icon, size: widget.size, color: widget.color),
    );
  }
}
