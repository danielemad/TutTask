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
        await localDatasource.cacheToken(remoteUser.token);

        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final cachedToken = await localDatasource.getCachedToken();
        if (cachedToken != null) {
          return Right(
            UserEntity(
              email: "PATIENT EMAIL",
              user: "PATIENT NAME",
              role: UserRoles.Patient, // Assuming the cached user is a patient
            ),
          );
        } else {
          return Left(Failure(errMessage: "NOUSER"));
        }
      } on CacheException catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }
}
