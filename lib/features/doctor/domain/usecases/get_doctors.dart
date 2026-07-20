import 'package:appointment_task/features/doctor/domain/repositories/doctor_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/doctor_entity.dart';

class GetDoctors {
  DoctorRepo repo;

  GetDoctors({required this.repo});

  Future<Either<Failure, List<DoctorEntity>>> call() async {
    return await repo.getDoctors();
  }
}
