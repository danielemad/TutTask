import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/doctor_entity.dart';

abstract class DoctorRepo {
  Future<Either<Failure, List<DoctorEntity>>> getDoctors();
}
