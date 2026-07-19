import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../repositories/appointment_repo.dart';

class BookAppointment {
  final AppointmentRepo repository;

  BookAppointment(this.repository);

  Future<Either<Failure, void>> call({
    required AppointmentParams params,
  }) async {
    return await repository.bookAppointment(params: params);
  }
}
