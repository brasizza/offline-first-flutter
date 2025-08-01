import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_container_usecase.dart';
part 'create_container_state.dart';

class CreateContainerCubit extends Cubit<CreateContainerState> {
  final CreateContainerUseCase useCase;

  CreateContainerCubit(this.useCase) : super(CreateContainerInitial());

  Future<void> load() async {
    emit(CreateContainerLoading());
    try {
      final data = await useCase();
      emit(CreateContainerSuccess(data));
    } catch (e) {
      emit(CreateContainerError(e.toString()));
    }
  }
}
