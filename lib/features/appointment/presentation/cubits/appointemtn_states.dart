import '../../domain/entities/appointment_entity.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentSubmitting extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  AppointmentLoaded(this.appointments);

  final List<AppointmentEntity> appointments;
}

class AppointmentError extends AppointmentState {
  AppointmentError(this.message);

  final String message;
}
