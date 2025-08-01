part of 'create_container_cubit.dart';

abstract class CreateContainerState {}

class CreateContainerInitial extends CreateContainerState {}

class CreateContainerLoading extends CreateContainerState {}

class CreateContainerSuccess extends CreateContainerState {
  final dynamic data;
  CreateContainerSuccess(this.data);
}

class CreateContainerLoadContainer extends CreateContainerState {
  final BoxContainerModel container;
  CreateContainerLoadContainer(this.container);
}

class CreateContainerError extends CreateContainerState {
  final String message;
  CreateContainerError(this.message);
}
