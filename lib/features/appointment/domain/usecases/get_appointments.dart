import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repo.dart';

class GetAppointments {
  final AppointmentRepo repository;

  GetAppointments(this.repository);

  Future<Either<Failure, List<AppointmentEntity>>> call() async {
    return await repository.getAppointments();
  }
}
