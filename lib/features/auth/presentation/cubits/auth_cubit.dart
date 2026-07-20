import 'package:appointment_task/core/params/params.dart';
import 'package:appointment_task/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:appointment_task/features/auth/domain/usecases/user_login.dart';
import 'package:appointment_task/features/auth/domain/usecases/user_logout.dart';
import 'package:appointment_task/features/auth/presentation/cubits/auth_states.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/cache/cache_helper.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInit());

  Future<void> eitherFailureOrUser({required UserLoginParams params}) async {
    emit(AuthLoading());
    final failureOrUser = await UserLogIn(
      repo: AuthRepoImpl(
        remoteDatasource: AuthRemoteDatasource(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
        localDatasource: AuthLocalDatasource(cache: CacheHelper()),
        networkInfo: NetworkInfoImpl(InternetConnection()),
      ),
    )(userLoginParams: params);

    failureOrUser.fold(
      (failure) => emit(AuthFailure(errMessage: failure.errMessage)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  void logOut() {
    emit(AuthLogout());
    UserLogout(
      repo: AuthRepoImpl(
        remoteDatasource: AuthRemoteDatasource(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
        localDatasource: AuthLocalDatasource(cache: CacheHelper()),
        networkInfo: NetworkInfoImpl(InternetConnection()),
      ),
    )();
  }
}
