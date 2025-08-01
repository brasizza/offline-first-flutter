import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/splash_usecase.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashUseCase useCase;

  SplashCubit(this.useCase) : super(SplashInitial());

  Future<void> load() async {
    emit(SplashLoading());
    try {
      final data = await useCase();
      emit(SplashSuccess(data));
    } catch (e) {
      emit(SplashError(e.toString()));
    }
  }
}
