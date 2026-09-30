import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/ui/theme/app_theme.dart';
import '../../../../data/models/item_container_model.dart';

/// Abre o bottom sheet de cadastro/edição de item. Retorna o item salvo ou `null` se cancelado.
Future<ItemContainerModel?> showItemFormSheet(
  BuildContext context, {
  ItemContainerModel? item,
  String? boxName,
}) {
  return showModalBottomSheet<ItemContainerModel>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ItemFormSheet(item: item, boxName: boxName),
  );
}

class ItemFormSheet extends StatefulWidget {
  final ItemContainerModel? item;
  final String? boxName;

  const ItemFormSheet({super.key, this.item, this.boxName});

  @override
  State<ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<ItemFormSheet> {
  static const _quickQuantities = [1, 5, 10, 25, 50];
  static const _maxQuantity = 9999;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;

  bool get _isEdit => widget.item != null;
  int get _quantity => int.tryParse(_quantityController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name);
    _descriptionController = TextEditingController(text: widget.item?.description);
    _quantityController = TextEditingController(text: '${widget.item?.quantity ?? 1}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _setQuantity(int value) {
    final quantity = value.clamp(1, _maxQuantity);
    HapticFeedback.selectionClick();
    setState(() {
      _quantityController.value = TextEditingValue(
        text: '$quantity',
        selection: TextSelection.collapsed(offset: '$quantity'.length),
      );
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      ItemContainerModel(
        id: widget.item?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        quantity: _quantity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final boxName = widget.boxName?.trim() ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Icon(
                      _isEdit ? Icons.edit_note_rounded : Icons.add_box_rounded,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_isEdit ? 'Editar item' : 'Novo item', style: text.titleLarge),
                        const SizedBox(height: 2),
                        Text(
                          boxName.isEmpty ? 'Preencha os dados do item' : 'No box "$boxName"',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                autofocus: !_isEdit,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome do item',
                  hintText: 'Ex.: Parafuso sextavado',
                  prefixIcon: Icon(Icons.label_outline_rounded),
                ),
                validator: (value) => (value?.trim().isEmpty ?? true) ? 'Informe o nome do item' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Detalhes, medidas, observações…',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Icon(Icons.notes_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Quantidade', style: text.titleSmall),
              const SizedBox(height: 10),
              _QuantityStepper(
                controller: _quantityController,
                canDecrement: _quantity > 1,
                onDecrement: () => _setQuantity(_quantity - 1),
                onIncrement: () => _setQuantity(_quantity + 1),
                onChanged: () => setState(() {}),
                validator: (value) => (int.tryParse(value ?? '') ?? 0) < 1 ? 'Mínimo 1' : null,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final value in _quickQuantities)
                    ChoiceChip(
                      label: Text('$value'),
                      selected: _quantity == value,
                      onSelected: (_) => _setQuantity(value),
                      labelStyle: text.labelLarge?.copyWith(
                        color: _quantity == value ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _submit,
                      icon: Icon(_isEdit ? Icons.check_rounded : Icons.add_rounded),
                      label: Text(_isEdit ? 'Salvar item' : 'Adicionar item'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final TextEditingController controller;
  final bool canDecrement;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onChanged;
  final FormFieldValidator<String> validator;

  const _QuantityStepper({
    required this.controller,
    required this.canDecrement,
    required this.onDecrement,
    required this.onIncrement,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const buttonSize = Size.square(52);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: canDecrement ? onDecrement : null,
            icon: const Icon(Icons.remove_rounded),
            style: IconButton.styleFrom(
              minimumSize: buttonSize,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (_) => onChanged(),
              validator: validator,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                filled: false,
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                suffixText: 'un.',
                suffixStyle: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          IconButton.filled(
            onPressed: onIncrement,
            icon: const Icon(Icons.add_rounded),
            style: IconButton.styleFrom(
              minimumSize: buttonSize,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
            ),
          ),
        ],
      ),
    );
  }
}
