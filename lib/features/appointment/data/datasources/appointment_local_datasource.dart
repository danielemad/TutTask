import 'dart:convert';

import '../../../../core/databases/cache/cache_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/appointment_model.dart';

class AppointmentLocalDatasource {
  final CacheHelper cacheHelper;

  AppointmentLocalDatasource(this.cacheHelper);

  static const String key = "cachedAppointments";

  Future<void> cacheAppointments(List<AppointmentModel> appointments) async {
    final jsonList = appointments
        .map((appointment) => appointment.toJson())
        .toList();

    await cacheHelper.saveData(key: key, value: jsonEncode(jsonList));
  }

  Future<List<AppointmentModel>> getCachedAppointments() async {
    final String? cachedData = await cacheHelper.getData(key: key);

    if (cachedData == null) {
      throw CacheException(errorMessage: "No cached appointments found");
    }

    final List<dynamic> decodedList = jsonDecode(cachedData);

    return decodedList
        .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearCachedAppointments() async {
    await cacheHelper.removeData(key: key);
  }
}
