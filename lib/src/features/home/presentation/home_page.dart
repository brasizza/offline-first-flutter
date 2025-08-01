import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';

import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Listagem de Containers'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.get<HomeCubit>().load();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cubit = context.get<HomeCubit>();
          await Navigator.of(context).pushNamed('/container/create');
          cubit.load();
          // Action for adding a new container
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: context.get(),
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeSuccess) {
            if (state.data?.isEmpty ?? true) {
              return const Center(child: Text('Nenhum container encontrado!'));
            }
            return ListView.builder(
              itemCount: state.data?.length ?? 0,
              itemBuilder: (context, index) {
                final container = state.data![index];
                return Dismissible(
                  key: Key(container.id),
                  onDismissed: (direction) {
                    context.get<HomeCubit>().deleteContainer(container);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        container.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Responsavel: ${container.responsiblePerson}'),
                          Text("Itens: ${container.items.length}"),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: container.isSynced ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          container.isSynced ? 'Sincronizado' : 'Offline',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () async {
                        final cubit = context.get<HomeCubit>();
                        await Navigator.of(context).pushNamed('/container/edit', arguments: container);
                        cubit.load();
                        // Action for tapping on a container
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is HomeError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Initial state'));
        },
      ),
    );
  }
}
