import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/docotor_model.dart';

class DoctorRemoteDatasource {
  final ApiConsumer _apiConsumer;

  DoctorRemoteDatasource({required this._apiConsumer});
  Future<List<DoctorModel>> getDoctors() async {
    final doctors = await _apiConsumer.get(EndPoints.doctors);

    return (doctors as List)
        .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
