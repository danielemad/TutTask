import 'package:appointment_task/core/databases/api/end_points.dart';

import '../../domain/entities/doctor_entity.dart';

class DoctorModel {
  int id;
  String fullName;
  String specialization;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.specialization,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json[ApiKey.id] ?? -100,
      fullName: json[ApiKey.doctorName] ?? "dummy name",
      specialization: json[ApiKey.specialization] ?? "general medicine",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.doctorName: fullName,
      ApiKey.specialization: specialization,
    };
  }

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      id: entity.id,
      fullName: entity.fullName,
      specialization: entity.specialization,
    );
  }

  DoctorEntity toEntity() {
    return DoctorEntity(
      id: id,
      specialization: specialization,
      fullName: fullName,
    );
  }
}
