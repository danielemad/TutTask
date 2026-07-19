import 'package:appointment_task/core/databases/cache/cache_helper.dart';
import 'package:appointment_task/features/appointment/data/datasources/appointment_local_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/params/params.dart';
import '../../data/datasources/appointment_remote_datasource.dart';
import '../../data/repositories/appointment_repo_impl.dart';
import 'appointemtn_states.dart';

class DoctorOption {
  const DoctorOption({
    required this.id,
    required this.name,
    required this.specialty,
  });

  final String id;
  final String name;
  final String specialty;

  factory DoctorOption.fromJson(Map<String, dynamic> json) {
    return DoctorOption(
      id: json[ApiKey.doctorId].toString(),
      name: json[ApiKey.doctorName],
      specialty: json[ApiKey.specialization],
    );
  }
}

class AppointmentCubit extends Cubit<AppointmentState> {
  Future<List<DoctorOption>> getDoctors() async {
    try {
      final dio = DioConsumer(dio: Dio());

      final response = await dio.get(
        "https://laziness-delirious-swampland.ngrok-free.dev/api/Patient/Doctors",
      );

      print(response);

      return (response as List)
          .map(
            (doctor) => DoctorOption.fromJson(doctor as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  AppointmentCubit() : super(AppointmentInitial()) {
    _remoteDatasource = AppointmentRemoteDatasource(DioConsumer(dio: Dio()));
    _localDatasource = AppointmentLocalDatasource(CacheHelper());
    _repository = AppointmentRepoImpl(
      remoteDatasource: _remoteDatasource,
      networkInfo: NetworkInfoImpl(InternetConnection()),
      localDatasource: _localDatasource,
    );
  }

  late final AppointmentRemoteDatasource _remoteDatasource;
  late final AppointmentRepoImpl _repository;
  late final AppointmentLocalDatasource _localDatasource;

  Future<void> loadAppointments({bool refresh = false}) async {
    emit(AppointmentLoading());

    final result = await _repository.getAppointments();

    result.fold(
      (failure) => emit(AppointmentError(failure.errMessage)),
      (appointments) => emit(AppointmentLoaded(appointments)),
    );
  }

  Future<bool> bookAppointment({
    required String doctorId,
    required DateTime appointmentDate,
  }) async {
    emit(AppointmentSubmitting());

    try {
      await _remoteDatasource.bookAppointment(
        AppointmentParams(doctorId: doctorId, appointmentDate: appointmentDate),
      );
      await loadAppointments(refresh: true);
      return true;
    } catch (e) {
      emit(AppointmentError('Unable to book your appointment right now.'));
      return false;
    }
  }

  Future<bool> cancelAppointment(int id) async {
    try {
      final result = await _repository.cancelAppointment(id);

      return result.fold(
        (failure) {
          emit(AppointmentError(failure.errMessage));
          return false;
        },
        (_) {
          if (state is AppointmentLoaded) {
            final current = (state as AppointmentLoaded).appointments;
            final updated = current
                .where((appointment) => appointment.id != id)
                .toList();
            emit(AppointmentLoaded(updated));
          } else {
            loadAppointments(refresh: true);
          }
          return true;
        },
      );
    } catch (e) {
      emit(AppointmentError('Unable to cancel appointment right now.'));
      return false;
    }
  }
}
