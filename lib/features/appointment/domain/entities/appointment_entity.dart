import 'package:flutter/material.dart';

import '../../../doctor/domain/entities/doctor_entity.dart';

enum AppointmentStatus { pending, cancelled, confirmed, completed, rejected }

extension AppointmentStatusExtension on AppointmentStatus {
  int get value {
    switch (this) {
      case AppointmentStatus.cancelled:
        return 4;
      case AppointmentStatus.confirmed:
        return 1;
      case AppointmentStatus.completed:
        return 3;
      case AppointmentStatus.rejected:
        return 2;
      default:
        return 0;
    }
  }

  Color get color {
    switch (this) {
      case AppointmentStatus.pending:
        return Colors.orange;

      case AppointmentStatus.confirmed:
        return Colors.green;

      case AppointmentStatus.completed:
        return Colors.blue;

      case AppointmentStatus.cancelled:
        return Colors.red;

      case AppointmentStatus.rejected:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case AppointmentStatus.pending:
        return Icons.schedule;

      case AppointmentStatus.cancelled:
        return Icons.cancel;

      case AppointmentStatus.confirmed:
        return Icons.check_circle;

      case AppointmentStatus.rejected:
        return Icons.highlight_off;

      case AppointmentStatus.completed:
        return Icons.task_alt;
    }
  }

  String get title {
    switch (this) {
      case AppointmentStatus.pending:
        return "Pending";
      case AppointmentStatus.cancelled:
        return "Cancelled";
      case AppointmentStatus.confirmed:
        return "Confirmed";
      case AppointmentStatus.rejected:
        return "Rejected";
      case AppointmentStatus.completed:
        return "Completed";
    }
  }
}

class AppointmentEntity {
  int? id;
  DateTime appointmentDate;
  String? notes;
  AppointmentStatus status;
  DoctorEntity doctor;

  bool get isCancelled => status == AppointmentStatus.cancelled;

  bool get isPast => appointmentDate.isBefore(DateTime.now());

  bool get canCancel => !isCancelled && !isPast;

  AppointmentEntity({
    this.id,
    this.notes,
    required this.status,
    required this.appointmentDate,
    required this.doctor,
  });
}
