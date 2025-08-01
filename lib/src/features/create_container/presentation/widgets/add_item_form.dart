import 'package:flutter/material.dart';
import 'package:offline_first/src/data/models/item_container_model.dart';
import 'package:uuid/uuid.dart';

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nome do item'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Descrição do item'),
          ),
          TextFormField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'Quantidade'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final description = descriptionController.text;
              final quantity = int.tryParse(quantityController.text) ?? 0;

              Navigator.of(context).pop(
                ItemContainerModel(
                  id: const Uuid().v4(),
                  name: name,
                  description: description,
                  quantity: quantity,
                ),
              );
            },
            child: const Text('Adicionar Item'),
          ),
        ],
      ),
    );
  }
}
