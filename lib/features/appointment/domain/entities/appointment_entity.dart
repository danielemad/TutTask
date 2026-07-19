class AppointmentEntity {
  String? id;
  String doctorId;
  DateTime appointmentDate;
  String status;
  String? notes;

  AppointmentEntity({
    this.id,
    required this.doctorId,
    required this.appointmentDate,
    this.notes,
  }) : status = appointmentDate.isAfter(DateTime.now())
           ? 'Pending'
           : 'Completed';
}
