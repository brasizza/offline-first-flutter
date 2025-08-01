import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:offline_first/src/core/ui/base_state_cubit.dart';
import 'package:offline_first/src/data/models/box_container_model.dart';

import 'cubit/create_container_cubit.dart';
import 'widgets/container_form.dart';

class CreateContainerPage extends StatefulWidget {
  const CreateContainerPage({super.key});

  @override
  State<CreateContainerPage> createState() => _CreateContainerPageState();
}

class _CreateContainerPageState extends BaseStateCubit<CreateContainerPage, CreateContainerCubit> {
  BoxContainerModel? _containerData;

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is BoxContainerModel) {
        bloc.loadContainer(args);
      } else {
        _containerData = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar container')),
      body: BlocBuilder<CreateContainerCubit, CreateContainerState>(
        bloc: context.get(),
        buildWhen: (previous, current) => current is CreateContainerLoadContainer || current is CreateContainerInitial,
        builder: (context, state) {
          if (state is CreateContainerLoadContainer) {
            _containerData = state.container;
          }
          return ContainerForm(
            initialData: _containerData,
            onSubmit: (BoxContainerModel container) async {
              final nav = Navigator.of(context);
              await context.get<CreateContainerCubit>().save(container);
              nav.pop();
            },
          );
        },
      ),
    );
  }
}
