import '../../../../core/errors/failure.dart';
import '../../domain/entities/doctor_entity.dart';

abstract class DoctorsStates {}

class DoctorsInitial extends DoctorsStates {}

class DoctorsLoading extends DoctorsStates {}

class DoctorsLoaded extends DoctorsStates {
  List<DoctorEntity> doctors;

  DoctorsLoaded({required this.doctors}) {
    print(doctors);
  }
}

class DoctorsFailed extends DoctorsStates {
  Failure failure;

  DoctorsFailed({required this.failure});
}
