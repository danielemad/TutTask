import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    super.id,
    required super.doctorId,
    required super.appointmentDate,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as int?,
      doctorId: json['doctorId'] as int,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
    };
  }
}
