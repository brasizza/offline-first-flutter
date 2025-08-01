import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/src/features/home/domain/usecases/home_usecase_list_local.dart';

import '../../../../data/models/box_container_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeUsecaseListLocal useCase;

  HomeCubit(this.useCase) : super(HomeInitial());

  Future<void> load() async {
    emit(HomeLoading());
    try {
      final data = await useCase();
      emit(HomeSuccess(data));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
