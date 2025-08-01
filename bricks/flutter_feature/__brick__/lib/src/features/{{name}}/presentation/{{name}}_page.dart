import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/{{name}}_cubit.dart';
import 'package:flutter_getit/flutter_getit.dart';

class {{name.pascalCase()}}Page extends StatelessWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{name}}')),
      body: BlocBuilder<{{name.pascalCase()}}Cubit, {{name.pascalCase()}}State>(
        bloc: context.get(),
        builder: (context, state) {
          if (state is {{name.pascalCase()}}Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is {{name.pascalCase()}}Success) {
            return Center(child: Text('Data loaded: \${state.data}'));
          } else if (state is {{name.pascalCase()}}Error) {
            return Center(child: Text('Error: \${state.message}'));
          }
          return const Center(child: Text('Initial state'));
        },
      ),
    );
  }
}
