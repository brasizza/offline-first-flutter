import 'package:flutter/material.dart';
import 'package:offline_first/src/core/ui/base_state_cubit.dart';
import 'package:offline_first/src/data/models/box_container_model.dart';

import '../../../core/ui/widgets/app_snack_bar.dart';
import '../../../core/ui/widgets/sync_badge.dart';
import 'cubit/create_container_cubit.dart';
import 'widgets/container_form.dart';

class CreateContainerPage extends StatefulWidget {
  const CreateContainerPage({super.key});

  @override
  State<CreateContainerPage> createState() => _CreateContainerPageState();
}

class _CreateContainerPageState extends BaseStateCubit<CreateContainerPage, CreateContainerCubit> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  BoxContainerModel? _containerData;
  bool _argumentsRead = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lê o box a editar (se houver) uma única vez, direto dos argumentos da rota.
    if (_argumentsRead) return;
    _argumentsRead = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    _containerData = args is BoxContainerModel ? args : null;
  }

  Future<void> _save(BoxContainerModel container) async {
    final nav = Navigator.of(context);
    await bloc.save(container);

    final state = bloc.state;
    if (state is CreateContainerSuccess && state.data == true) {
      nav.pop(true);
    } else {
      _messengerKey.currentState?.showMessage(
        state is CreateContainerError ? state.message : 'Não foi possível salvar o box. Tente novamente.',
        icon: Icons.error_outline_rounded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final container = _containerData;

    // Messenger próprio: snackbars desta tela (ex.: "Desfazer" de item) não vazam para a Home.
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(container == null ? 'Novo box' : 'Editar box'),
          actions: [
            if (container != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SyncBadge(isSynced: container.isSynced),
              ),
          ],
        ),
        body: ContainerForm(
          initialData: container,
          onSubmit: _save,
        ),
      ),
    );
  }
}
