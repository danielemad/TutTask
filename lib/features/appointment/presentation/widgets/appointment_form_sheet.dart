import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/appointment_cubit.dart';

class AppointmentFormSheet extends StatefulWidget {
  const AppointmentFormSheet({super.key});

  @override
  State<AppointmentFormSheet> createState() => _AppointmentFormSheetState();
}

class _AppointmentFormSheetState extends State<AppointmentFormSheet> {
  String? selectedDoctorId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  late Future<List<DoctorOption>> doctorsFuture;

  @override
  initState() {
    super.initState();
    doctorsFuture = context.read<AppointmentCubit>().getDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentCubit>();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Book an appointment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Doctors Dropdown
          FutureBuilder<List<DoctorOption>>(
            future: doctorsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Text(
                  'Failed to load doctors',
                  style: TextStyle(color: Colors.red),
                );
              }

              final doctors = snapshot.data ?? [];

              return DropdownButtonFormField<String>(
                value: selectedDoctorId,
                decoration: const InputDecoration(
                  labelText: 'Select doctor',
                  border: OutlineInputBorder(),
                ),
                items: doctors
                    .map(
                      (doctor) => DropdownMenuItem<String>(
                        value: doctor.id,
                        child: Text('${doctor.name} • ${doctor.specialty}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDoctorId = value;
                  });
                },
              );
            },
          ),

          const SizedBox(height: 12),

          /// Date Picker
          InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );

              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Pick date',
                border: OutlineInputBorder(),
              ),
              child: Text(
                selectedDate == null
                    ? 'Choose date'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Time Picker
          InkWell(
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                setState(() {
                  selectedTime = pickedTime;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Pick time',
                border: OutlineInputBorder(),
              ),
              child: Text(
                selectedTime == null
                    ? 'Choose time'
                    : selectedTime!.format(context),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  selectedDoctorId != null &&
                      selectedDate != null &&
                      selectedTime != null
                  ? () async {
                      final dateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );

                      final success = await cubit.bookAppointment(
                        doctorId: selectedDoctorId!,
                        appointmentDate: dateTime,
                      );

                      if (!mounted) return;

                      if (success) {
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Appointment booked successfully.'),
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('Book appointment'),
            ),
          ),
        ],
      ),
    );
  }
}
