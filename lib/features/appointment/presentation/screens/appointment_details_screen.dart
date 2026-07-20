import 'package:appointment_task/features/appointment/domain/entities/appointment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/appointment_cubit.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key, required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final isCancelable = appointment.appointmentDate.isAfter(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoTile(title: 'Doctor', value: appointment.doctor.fullName),
            _InfoTile(
              title: 'Specialty',
              value: appointment.doctor.specialization,
            ),
            _InfoTile(
              title: 'Date',
              value: appointment.appointmentDate.toIso8601String(),
            ),
            _InfoTile(title: 'Status', value: appointment.status.title),
            if (appointment.notes != null && appointment.notes!.isNotEmpty)
              _InfoTile(title: 'Notes', value: appointment.notes!),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: appointment.canCancel
                    ? () => _cancelAppointment(context)
                    : null,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel Appointment'),
              ),
            ),
            if (!appointment.canCancel)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Only pending appointments booked with enough time remaining can be cancelled.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelAppointment(BuildContext context) async {
    final cubit = context.read<AppointmentCubit>();
    final success = await cubit.cancelAppointment(appointment.id!);

    if (!context.mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment cancelled successfully.')),
      );
    }
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
