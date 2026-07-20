import 'package:appointment_task/core/connection/network_info.dart';
import 'package:appointment_task/features/doctor/data/datasources/doctor_remote_datasource.dart';
import 'package:appointment_task/features/doctor/data/repositories/doctor_repo_impl.dart';
import 'package:appointment_task/features/doctor/domain/usecases/get_doctors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import 'doctor_states.dart';

class DoctorCubit extends Cubit<DoctorsStates> {
  DoctorCubit() : super(DoctorsInitial());

  Future<void> getDoctors() async {
    emit(DoctorsLoading());
    final doctors = await GetDoctors(
      repo: DoctorRepoImpl(
        remoteDatasource: DoctorRemoteDatasource(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
        networkInfo: NetworkInfoImpl(InternetConnection()),
      ),
    )();

    doctors.fold(
      (failure) => emit(DoctorsFailed(failure: failure)),
      (doctors) => emit(DoctorsLoaded(doctors: doctors)),
    );
  }
}
