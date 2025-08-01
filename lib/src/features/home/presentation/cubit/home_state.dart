part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<BoxContainerModel>? data;
  HomeSuccess(this.data);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
