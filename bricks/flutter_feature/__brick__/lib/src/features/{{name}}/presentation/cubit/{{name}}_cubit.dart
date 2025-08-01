import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/{{name}}_usecase.dart';
part '{{name}}_state.dart';

class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> {
  final {{name.pascalCase()}}UseCase useCase;

  {{name.pascalCase()}}Cubit(this.useCase) : super({{name.pascalCase()}}Initial());

  Future<void> load() async {
    emit({{name.pascalCase()}}Loading());
    try {
      final data = await useCase();
      emit({{name.pascalCase()}}Success(data));
    } catch (e) {
      emit({{name.pascalCase()}}Error(e.toString()));
    }
  }
}
