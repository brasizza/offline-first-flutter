import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../../../core/connection_check/connection_check.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/ui/formatters.dart';
import '../../../core/ui/theme/status_colors.dart';
import '../../../core/ui/widgets/app_snack_bar.dart';
import '../../../core/ui/widgets/empty_state.dart';
import '../../../core/ui/widgets/staggered_entrance.dart';
import '../../../core/ui/widgets/sync_status_pill.dart';
import '../../../data/models/box_container_model.dart';
import 'cubit/home_cubit.dart';
import 'widgets/box_card.dart';
import 'widgets/box_card_skeleton.dart';
import 'widgets/sync_overview_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _syncNow(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.get<HomeCubit>();
    final sync = context.get<SyncService>();

    if (!await ConnectionCheck.isConnected()) {
      messenger.showMessage(
        'Sem conexão — seus dados continuam salvos no dispositivo.',
        icon: Icons.cloud_off_rounded,
      );
      return;
    }
    await sync.sincronizarPendencias();
    await cubit.load();
  }

  Future<void> _openForm(
    BuildContext context, [
    BoxContainerModel? container,
  ]) async {
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.get<HomeCubit>();
    final connection = context.get<ConnectionCheck>();

    final saved = await Navigator.of(context).pushNamed(
      container == null ? '/container/create' : '/container/edit',
      arguments: container,
    );
    cubit.load();

    if (saved == true) {
      final online = connection.isOnline.value;
      messenger.showMessage(
        online ? 'Box salvo no dispositivo · sincronizando com a nuvem…' : 'Box salvo no dispositivo · será enviado quando houver conexão.',
        icon: online ? Icons.cloud_upload_rounded : Icons.save_rounded,
      );
    }
  }

  Future<bool> _confirmDelete(
    BuildContext context,
    BoxContainerModel container,
  ) async {
    final colors = context.statusColors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.dangerContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: colors.danger,
            size: 28,
          ),
        ),
        title: const Text('Excluir box?'),
        content: Text(
          '"${container.name}" e ${plural(container.items.length, 'item', 'itens')} serão removidos. '
          'A exclusão é enviada para a nuvem na próxima sincronização.',
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.danger,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Excluir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.get<HomeCubit>();

    // A Home não tem AppBar: define aqui a cor dos ícones da status bar (a splash deixa claros).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(context),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Novo box'),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          bloc: cubit,
          builder: (context, state) {
            final boxes = state is HomeSuccess ? state.data ?? const <BoxContainerModel>[] : const <BoxContainerModel>[];
            final itemCount = boxes.fold<int>(
              0,
              (sum, box) => sum + box.items.length,
            );

            return SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () => _syncNow(context),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    const SliverToBoxAdapter(child: _Header()),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: SyncOverviewCard(
                          boxCount: boxes.length,
                          itemCount: itemCount,
                          onSyncNow: () => _syncNow(context),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _SectionHeader(count: boxes.length),
                    ),
                    ...switch (state) {
                      HomeError(:final message) => [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyState(
                            icon: Icons.error_outline_rounded,
                            color: context.statusColors.danger,
                            title: 'Algo deu errado',
                            message: message,
                            actionLabel: 'Tentar novamente',
                            actionIcon: Icons.refresh_rounded,
                            onAction: cubit.load,
                          ),
                        ),
                      ],
                      HomeSuccess() when boxes.isEmpty => [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyState(
                            icon: Icons.inventory_2_outlined,
                            title: 'Nenhum box por aqui',
                            message: 'Crie seu primeiro box. Ele fica salvo no dispositivo e é sincronizado automaticamente quando houver internet.',
                            actionLabel: 'Criar primeiro box',
                            onAction: () => _openForm(context),
                          ),
                        ),
                      ],
                      HomeSuccess() => [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverList.separated(
                            itemCount: boxes.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final container = boxes[index];
                              return StaggeredEntrance(
                                key: ValueKey(container.id),
                                index: index,
                                child: _DismissibleBox(
                                  container: container,
                                  confirmDismiss: () => _confirmDelete(context, container),
                                  onDismissed: () {
                                    cubit.deleteContainer(container);
                                    ScaffoldMessenger.of(context).showMessage(
                                      '"${container.name}" removido · a nuvem será atualizada na próxima sincronização.',
                                      icon: Icons.delete_sweep_rounded,
                                    );
                                  },
                                  onTap: () => _openForm(context, container),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      _ => [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverList.separated(
                            itemCount: 4,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (_, _) => const BoxCardSkeleton(),
                          ),
                        ),
                      ],
                    },
                    const SliverToBoxAdapter(child: SizedBox(height: 112)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá 👋',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text('Meus Boxes', style: theme.textTheme.headlineMedium),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: SyncStatusPill(),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final int count;
  const _SectionHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      child: Row(
        children: [
          Text('Boxes', style: theme.textTheme.titleMedium),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Container(
              key: ValueKey(count),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '$count',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Spacer(),
          if (count > 0)
            Text(
              'Deslize para excluir',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _DismissibleBox extends StatelessWidget {
  final BoxContainerModel container;
  final Future<bool> Function() confirmDismiss;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  const _DismissibleBox({
    required this.container,
    required this.confirmDismiss,
    required this.onDismissed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.statusColors;
    return Dismissible(
      key: Key(container.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => confirmDismiss(),
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: colors.dangerContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Excluir',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.danger),
            ),
            const SizedBox(width: 8),
            Icon(Icons.delete_outline_rounded, color: colors.danger),
          ],
        ),
      ),
      child: BoxCard(container: container, onTap: onTap),
    );
  }
}
