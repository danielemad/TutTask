// class TemplateParams {
//   final String id;
//   TemplateParams({required this.id});
// }

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({required this.email, required this.password});
}

class AppointmentParams {
  final String doctorId;
  final DateTime appointmentDate;

  AppointmentParams({required this.doctorId, required this.appointmentDate});
}
