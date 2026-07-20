import 'package:appointment_task/core/errors/failure.dart';

import 'package:appointment_task/core/params/params.dart';
import 'package:appointment_task/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:appointment_task/features/auth/data/datasources/auth_remote_datasource.dart';

import 'package:appointment_task/features/auth/domain/entities/user_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  AuthRepoImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, UserEntity>> userLogIn({
    required UserLoginParams userLoginParams,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDatasource.userLogIn(
          userLoginParams: userLoginParams,
        );
        await localDatasource.saveToken(
          remoteUser.token,
          DateTime.now().add(Duration(hours: 1)),
        );

        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection"));
    }
  }

  @override
  void userLogOut() async {
    await localDatasource.clearCachedToken();
  }
}
