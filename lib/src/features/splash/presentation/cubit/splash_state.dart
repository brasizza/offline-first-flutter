part of 'splash_cubit.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashSuccess extends SplashState {
  final bool data;
  SplashSuccess(this.data);
}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}
