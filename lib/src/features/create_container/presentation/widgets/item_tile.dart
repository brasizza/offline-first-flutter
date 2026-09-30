import 'package:flutter/material.dart';

import '../../../../data/models/item_container_model.dart';

class ItemTile extends StatelessWidget {
  final ItemContainerModel item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const ItemTile({super.key, required this.item, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final name = item.name.trim();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  name.isEmpty ? '?' : name.characters.first.toUpperCase(),
                  style: text.titleMedium?.copyWith(color: scheme.onSecondaryContainer),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.titleSmall),
                    if (item.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.description.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '×${item.quantity}',
                  style: text.labelLarge?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                tooltip: 'Remover item',
                icon: Icon(Icons.close_rounded, size: 20, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
