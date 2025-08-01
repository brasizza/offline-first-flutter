part of '{{name}}_cubit.dart';

abstract class {{name.pascalCase()}}State {}

class {{name.pascalCase()}}Initial extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}Loading extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}Success extends {{name.pascalCase()}}State {
  final dynamic data;
  {{name.pascalCase()}}Success(this.data);
}

class {{name.pascalCase()}}Error extends {{name.pascalCase()}}State {
  final String message;
  {{name.pascalCase()}}Error(this.message);
}
