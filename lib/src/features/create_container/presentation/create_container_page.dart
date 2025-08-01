import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'cubit/create_container_cubit.dart';

class CreateContainerPage extends StatelessWidget {
  const CreateContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('create_container')),
      body: BlocBuilder<CreateContainerCubit, CreateContainerState>(
        bloc: context.get(),
        builder: (context, state) {
          if (state is CreateContainerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CreateContainerSuccess) {
            return const Center(child: Text('Data loaded: \${state.data}'));
          } else if (state is CreateContainerError) {
            return const Center(child: Text('Error: \${state.message}'));
          }
          return const Center(child: Text('Initial state'));
        },
      ),
    );
  }
}
