import 'package:appointment_task/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctor_repo.dart';
import '../datasources/doctor_remote_datasource.dart';

class DoctorRepoImpl implements DoctorRepo {
  DoctorRemoteDatasource _remoteDatasource;
  NetworkInfo _networkInfo;
  DoctorRepoImpl({required this._remoteDatasource, required this._networkInfo});

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctors() async {
    if (await _networkInfo.isConnected) {
      try {
        final doctors = await _remoteDatasource.getDoctors();
        return Right(doctors.map((doctor) => doctor.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "No Internet Connection"));
    }
  }
}
