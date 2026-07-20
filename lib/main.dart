import 'package:appointment_task/core/databases/cache/cache_helper.dart';
import 'package:appointment_task/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/appointment/presentation/screens/appointments_screen.dart';
import 'features/auth/presentation/cubits/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localDatasource = AuthLocalDatasource(cache: CacheHelper());
  final token = await localDatasource.getCachedToken();
  bool isExpired = true;
  if (token != null) {
    isExpired = DateTime.now().isAfter(DateTime.parse(token["expireDate"]));
    if (isExpired) {
      await localDatasource.clearCachedToken();
    }
  }

  runApp(MyApp(hasValidToken: isExpired));
}

class MyApp extends StatelessWidget {
  final bool hasValidToken;
  const MyApp({super.key, required this.hasValidToken});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'Appointment Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: hasValidToken
            ? LoginScreen()
            : AppointmentsScreen(), // Set the initial screen to LoginScreen
      ),
    );
  }
}
