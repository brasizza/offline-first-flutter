import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/src/features/home/domain/usecases/home_usecase_list_local.dart';

import '../../../../data/models/box_container_model.dart';
import '../../domain/usecases/home_usecase_delete_local.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeUsecaseListLocal useCase;
  final HomeUsecaseDeleteLocal deleteUseCase;

  HomeCubit(this.useCase, this.deleteUseCase) : super(HomeInitial());

  Future<void> load() async {
    // Recarregamentos (ex.: após cada sincronização) mantêm a lista na tela sem piscar o loading.
    if (state is! HomeSuccess) emit(HomeLoading());
    try {
      final data = await useCase();
      emit(HomeSuccess(data));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void deleteContainer(BoxContainerModel container) async {
    // Remoção otimista: o Dismissible exige que o item saia da árvore imediatamente.
    final current = state;
    if (current is HomeSuccess) {
      emit(HomeSuccess(current.data?.where((c) => c.id != container.id).toList()));
    }
    try {
      final success = await deleteUseCase(container);
      if (success) {
        emit(HomeSuccess(await useCase()));
      } else {
        emit(HomeError('Failed to delete container'));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
