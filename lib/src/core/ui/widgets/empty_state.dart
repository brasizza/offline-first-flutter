import 'package:flutter/material.dart';

/// Estado vazio/erro com ícone destacado, textos e ação opcional.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final Color? color;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [accent.withValues(alpha: 0.18), accent.withValues(alpha: 0.04)],
              ),
            ),
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, size: 32, color: accent),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(title, textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon ?? Icons.add_rounded),
              label: Text(actionLabel!),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 52),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
