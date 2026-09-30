import 'package:flutter/material.dart';

import '../../../../core/ui/formatters.dart';
import '../../../../core/ui/widgets/sync_badge.dart';
import '../../../../data/models/box_container_model.dart';

class BoxCard extends StatelessWidget {
  final BoxContainerModel container;
  final VoidCallback onTap;

  const BoxCard({super.key, required this.container, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final units = container.items.fold<int>(0, (sum, item) => sum + item.quantity);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primaryContainer, scheme.primaryContainer.withValues(alpha: 0.5)],
                  ),
                ),
                child: Icon(Icons.inventory_2_rounded, color: Colors.white.withValues(alpha: 0.5), size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            container.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SyncBadge(isSynced: container.isSynced),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_outline_rounded, size: 15, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            container.responsiblePerson.isEmpty ? 'Sem responsável' : container.responsiblePerson,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _MetaChip(icon: Icons.category_outlined, label: plural(container.items.length, 'item', 'itens')),
                        const SizedBox(width: 8),
                        _MetaChip(icon: Icons.layers_outlined, label: '$units un.'),
                        const Spacer(),
                        Text(
                          relativeTime(container.updatedAt),
                          style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant.withValues(alpha: 0.8)),
                        ),
                        Icon(Icons.chevron_right_rounded, size: 18, color: scheme.onSurfaceVariant.withValues(alpha: 0.6)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
