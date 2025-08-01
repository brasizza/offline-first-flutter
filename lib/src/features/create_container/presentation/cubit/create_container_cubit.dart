import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/src/data/models/box_container_model.dart';

import '../../domain/usecases/create_container_usecase.dart';

part 'create_container_state.dart';

class CreateContainerCubit extends Cubit<CreateContainerState> {
  final CreateContainerUseCase useCase;

  CreateContainerCubit(this.useCase) : super(CreateContainerInitial());

  Future<void> save(BoxContainerModel container) async {
    emit(CreateContainerLoading());
    try {
      final data = await useCase(container);
      emit(CreateContainerSuccess(data));
    } catch (e) {
      emit(CreateContainerError(e.toString()));
    }
  }

  void loadContainer(BoxContainerModel container) {
    emit(CreateContainerLoadContainer(container));
  }
}
