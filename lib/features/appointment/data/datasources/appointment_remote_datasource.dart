import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/params/params.dart';

class AppointmentRemoteDatasource {
  final ApiConsumer _apiConsumer;

  AppointmentRemoteDatasource(this._apiConsumer);

  Future<void> bookAppointment(AppointmentParams params) async {
    final x = await _apiConsumer.post(
      EndPoints.bookAppointment,
      data: {
        "doctorId": params.doctorId,
        "appointmentDate": params.appointmentDate.toIso8601String(),
      },
    );
  }

  Future<void> cancelAppointment(int id) async {
    await _apiConsumer.delete("${EndPoints.cancelAppointment}/$id");
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    final response = await _apiConsumer.get(EndPoints.appointments);
    return List<Map<String, dynamic>>.from(response);
  }
}
