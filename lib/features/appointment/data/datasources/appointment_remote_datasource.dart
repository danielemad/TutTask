import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/params/params.dart';

class AppointmentRemoteDatasource {
  final ApiConsumer _apiConsumer;

  AppointmentRemoteDatasource(this._apiConsumer);

  Future<void> bookAppointment(AppointmentParams params) async {
    await _apiConsumer.post(
      EndPoints.bookAppointment,
      data: {
        ApiKey.doctorId: params.doctorId,
        ApiKey.appointmentDate: params.appointmentDate,
      },
    );
  }

  Future<void> cancelAppointment(String id) async {
    await _apiConsumer.delete("${EndPoints.cancelAppointment}/$id");
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    final response = await _apiConsumer.get(EndPoints.appointments);
    return response.data as List<Map<String, dynamic>>;
  }
}
