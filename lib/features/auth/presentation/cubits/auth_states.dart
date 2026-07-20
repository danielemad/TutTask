import '../../domain/entities/user_entity.dart';

class AuthState {}

class AuthInit extends AuthState {}

class AuthSuccess extends AuthState {
  UserEntity user;
  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  String errMessage;

  AuthFailure({required this.errMessage});
}

class AuthLoading extends AuthState {}

class AuthLogout extends AuthState {}
