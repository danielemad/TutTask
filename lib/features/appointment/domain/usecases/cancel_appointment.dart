import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/appointment_repo.dart';

class CancelAppointment {
  final AppointmentRepo repository;

  CancelAppointment(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.cancelAppointment(id);
  }
}
