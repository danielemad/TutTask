import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repo.dart';
import '../datasources/appointment_local_datasource.dart';
import '../datasources/appointment_remote_datasource.dart';
import '../models/appointment_model.dart';

class AppointmentRepoImpl implements AppointmentRepo {
  AppointmentRemoteDatasource remoteDatasource;
  AppointmentLocalDatasource localDatasource;
  NetworkInfo networkInfo;

  AppointmentRepoImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, void>> bookAppointment({
    required AppointmentParams params,
  }) async {
    try {
      await remoteDatasource.bookAppointment(params);
      return Right(null);
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(String id) async {
    try {
      await remoteDatasource.cancelAppointment(id);
      return Right(null);
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments() async {
    if (await networkInfo.isConnected) {
      try {
        final repsonse = await remoteDatasource.getAppointments();
        final appointments = repsonse
            .map((e) => AppointmentModel.fromJson(e))
            .toList();
        localDatasource.cacheAppointments(appointments);
        return Right(appointments);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final cachedAppointments = await localDatasource
            .getCachedAppointments();
        return Right(cachedAppointments);
      } on CacheException catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }
}
