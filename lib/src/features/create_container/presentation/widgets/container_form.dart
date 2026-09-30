import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:offline_first/src/data/models/box_container_model.dart';
import 'package:offline_first/src/data/models/item_container_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/ui/formatters.dart';
import '../../../../core/ui/theme/app_theme.dart';
import '../../../../core/ui/widgets/app_snack_bar.dart';
import '../../../../core/ui/widgets/staggered_entrance.dart';
import 'item_form_sheet.dart';
import 'item_tile.dart';

class ContainerForm extends StatefulWidget {
  final BoxContainerModel? initialData;
  final Future<void> Function(BoxContainerModel container) onSubmit;
  const ContainerForm({super.key, this.initialData, required this.onSubmit});

  @override
  State<ContainerForm> createState() => _ContainerFormState();
}

class _ContainerFormState extends State<ContainerForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController responsibleController;

  /// Cópia da lista: editar/remover itens não altera o objeto do Hive antes de salvar.
  late final List<ItemContainerModel> items;
  bool _saving = false;

  bool get _isEdit => widget.initialData != null;
  int get _units => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialData?.name);
    responsibleController = TextEditingController(text: widget.initialData?.responsiblePerson);
    items = List.of(widget.initialData?.items ?? const <ItemContainerModel>[]);
  }

  @override
  void dispose() {
    nameController.dispose();
    responsibleController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    final newItem = await showItemFormSheet(context, boxName: nameController.text);
    if (newItem != null) setState(() => items.add(newItem));
  }

  Future<void> _editItem(int index) async {
    final updated = await showItemFormSheet(context, item: items[index], boxName: nameController.text);
    if (updated != null) setState(() => items[index] = updated);
  }

  void _removeItem(int index) {
    final removed = items[index];
    setState(() => items.removeAt(index));
    ScaffoldMessenger.of(context).showMessage(
      '"${removed.name}" removido do box',
      icon: Icons.remove_circle_outline_rounded,
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          if (!mounted) return;
          setState(() => items.insert(index.clamp(0, items.length), removed));
        },
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();
    final initialData = widget.initialData;
    final container = initialData != null
        ? initialData.copyWith(
            name: nameController.text.trim(),
            responsiblePerson: responsibleController.text.trim(),
            items: List.of(items),
            isSynced: false,
            updatedAt: now,
          )
        : BoxContainerModel(
            id: const Uuid().v4(),
            name: nameController.text.trim(),
            responsiblePerson: responsibleController.text.trim(),
            items: List.of(items),
            createdAt: now,
            updatedAt: now,
            isSynced: false,
            isDeleted: false,
          );

    setState(() => _saving = true);
    try {
      await widget.onSubmit(container);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Form(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _SectionCard(
                  icon: Icons.inventory_2_rounded,
                  title: 'Informações do box',
                  subtitle: 'Identifique o box e quem cuida dele',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nome do box',
                          hintText: 'Ex.: Estoque A — Prateleira 3',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                        ),
                        validator: (value) => (value?.trim().isEmpty ?? true) ? 'Informe o nome do box' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: responsibleController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Responsável',
                          hintText: 'Quem cuida deste box?',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) => (value?.trim().isEmpty ?? true) ? 'Informe o responsável' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Itens', style: text.titleMedium),
                          const SizedBox(height: 2),
                          Text(
                            '${plural(items.length, 'item', 'itens')} · ${plural(_units, 'unidade', 'unidades')}',
                            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Adicionar'),
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.primary.withValues(alpha: 0.12),
                        foregroundColor: scheme.primary,
                        minimumSize: const Size(0, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (items.isEmpty)
                  _EmptyItems(onAdd: _addItem)
                else
                  for (final (index, item) in items.indexed)
                    Padding(
                      key: ValueKey(item.id),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: StaggeredEntrance(
                        index: 0,
                        child: Dismissible(
                          key: ValueKey('dismiss-${item.id}'),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _removeItem(index),
                          background: const _RemoveBackground(),
                          child: ItemTile(
                            item: item,
                            onTap: () => _editItem(index),
                            onRemove: () => _removeItem(index),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          _BottomBar(
            saving: _saving,
            label: _isEdit ? 'Salvar alterações' : 'Salvar box',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({required this.icon, required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.5)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleSmall),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _EmptyItems extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyItems({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return CustomPaint(
      painter: _DashedBorderPainter(color: scheme.outlineVariant, radius: AppTheme.radiusLg),
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add_shopping_cart_rounded, color: scheme.primary),
              ),
              const SizedBox(height: 12),
              Text('Nenhum item ainda', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                'Toque para adicionar o primeiro item deste box',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoveBackground extends StatelessWidget {
  const _RemoveBackground();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Icon(Icons.delete_outline_rounded, color: scheme.error),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool saving;
  final String label;
  final VoidCallback onPressed;

  const _BottomBar({required this.saving, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.offline_bolt_rounded, size: 15, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    'Salvo no dispositivo e sincronizado automaticamente',
                    style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: saving ? null : onPressed,
                  icon: saving
                      ? SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(saving ? 'Salvando…' : label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 7.0;
    const gap = 5.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    for (final PathMetric metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => oldDelegate.color != color || oldDelegate.radius != radius;
}
