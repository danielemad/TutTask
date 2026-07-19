import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentRepo {
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments();
  Future<Either<Failure, void>> bookAppointment({
    required AppointmentParams params,
  });
  Future<Either<Failure, void>> cancelAppointment(int id);
}
