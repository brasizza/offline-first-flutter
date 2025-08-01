import 'package:flutter/material.dart';
import 'package:offline_first/src/data/models/box_container_model.dart';
import 'package:offline_first/src/data/models/item_container_model.dart';
import 'package:uuid/uuid.dart';

import 'add_item_form.dart';

class ContainerForm extends StatefulWidget {
  final BoxContainerModel? initialData;
  final void Function(BoxContainerModel container) onSubmit;
  const ContainerForm({super.key, this.initialData, required this.onSubmit});

  @override
  State<ContainerForm> createState() => _ContainerFormState();
}

class _ContainerFormState extends State<ContainerForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();
  List<ItemContainerModel> items = [];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    responsibleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialData != null) {
      nameController.text = widget.initialData!.name;
      responsibleController.text = widget.initialData!.responsiblePerson;
      items = widget.initialData!.items;
    } else {
      items = [];
    }

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nome do container'),
              controller: nameController,
              // Add validation and other properties as needed
            ),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Responsável'),
              controller: responsibleController,
              // Add validation and other properties as needed
            ),
            const SizedBox(height: 30),
            //criar uma estrutura de textformField pra cadastrar os itens do container
            Text('Itens do container', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            // If initial data is provided, populate the fields

            //cria uma estrutura pra cadastrar o item do container
            Column(
              children: [
                ...items.map((item) {
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Quantidade: ${item.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          items.remove(item);
                        });
                      },
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: () async {
                    final ItemContainerModel? newItem = await showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text('Adicionar Item'),
                          content: SingleChildScrollView(child: AddItemForm()),
                        );
                      },
                    );
                    if (newItem != null) {
                      setState(() {
                        items.add(newItem);
                      });
                    }
                  },
                  child: const Text('Adicionar item'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                BoxContainerModel? initialData = widget.initialData;
                if (formKey.currentState?.validate() ?? false) {
                  if (initialData != null) {
                    // Update existing container
                    final updatedContainer = initialData.copyWith(
                      name: nameController.text,
                      responsiblePerson: responsibleController.text,
                      items: items,
                      isSynced: false,
                      updatedAt: DateTime.now(),
                    );
                    widget.onSubmit(updatedContainer);
                  } else {
                    initialData = BoxContainerModel(
                      name: nameController.text,
                      responsiblePerson: responsibleController.text,
                      id: const Uuid().v4(),
                      items: items,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      isSynced: false,
                      isDeleted: false,
                    );
                    widget.onSubmit(initialData);
                  }
                }
              },
              child: widget.initialData != null ? const Text('Atualizar container') : const Text('Salvar container'),
            ),
          ],
        ),
      ),
    );
  }
}
