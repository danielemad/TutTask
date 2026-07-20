import 'package:appointment_task/core/databases/api/end_points.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../../doctor/data/models/docotor_model.dart';

class AppointmentModel {
  int? id;
  DateTime appointmentDate;
  DoctorModel doctor;
  int status;
  String? notes;

  AppointmentModel({
    this.id,
    required this.appointmentDate,
    required this.doctor,
    required this.status,
    this.notes,
  });

  AppointmentStatus statusFromInt(int value) {
    switch (value) {
      case 1:
        return AppointmentStatus.confirmed;
      case 2:
        return AppointmentStatus.rejected;
      case 3:
        return AppointmentStatus.completed;
      case 4:
        return AppointmentStatus.cancelled;
      default:
        return AppointmentStatus.pending;
    }
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json[ApiKey.id],
      appointmentDate: DateTime.parse(json[ApiKey.appointmentDate]),
      doctor: DoctorModel.fromJson(json[ApiKey.doctor]),
      notes: json[ApiKey.notes],
      status: json[ApiKey.status],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.appointmentDate: appointmentDate.toIso8601String(),
      ApiKey.doctor: doctor.toJson(),
      ApiKey.status: status,
      ApiKey.notes: notes,
    };
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      appointmentDate: entity.appointmentDate,
      doctor: DoctorModel.fromEntity(entity.doctor),
      id: entity.id,
      status: entity.status.value,
      notes: entity.notes,
    );
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      appointmentDate: appointmentDate,
      notes: notes,
      status: statusFromInt(status),
      doctor: doctor.toEntity(),
    );
  }
}
