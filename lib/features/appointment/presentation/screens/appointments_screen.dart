import 'package:appointment_task/features/appointment/domain/entities/appointment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/appointemtn_states.dart';
import '../cubits/appointment_cubit.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_form_sheet.dart';
import '../widgets/empty_state.dart';
import 'appointment_details_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentCubit()..loadAppointments(),
      child: const _AppointmentsView(),
    );
  }
}

class _AppointmentsView extends StatelessWidget {
  const _AppointmentsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AppointmentCubit>().loadAppointments(
              refresh: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBookingForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Book'),
      ),
      body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading || state is AppointmentSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppointmentError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context
                          .read<AppointmentCubit>()
                          .loadAppointments(refresh: true),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AppointmentLoaded) {
            final appointments = state.appointments;

            if (appointments.isEmpty) {
              return const EmptyStateWidget(
                title: 'No appointments yet',
                message:
                    'You will see your booked appointments here after you create one.',
              );
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<AppointmentCubit>()
                  .loadAppointments(refresh: true),
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return AppointmentCard(
                    appointment: appointment,
                    onTap: () => _openDetails(context, appointment),
                  );
                },
              ),
            );
          }

          return const EmptyStateWidget(
            title: 'No appointments yet',
            message: 'Your scheduled appointments will appear here.',
          );
        },
      ),
    );
  }

  void _showBookingForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AppointmentCubit>(),
        child: const AppointmentFormSheet(),
      ),
    );
  }

  void _openDetails(BuildContext context, AppointmentEntity appointment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AppointmentCubit>(),
          child: AppointmentDetailsScreen(appointment: appointment),
        ),
      ),
    );
  }
}
