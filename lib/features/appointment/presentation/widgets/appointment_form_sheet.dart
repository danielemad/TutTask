import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../doctor/presentation/cubits/doctor_cubit.dart';
import '../../../doctor/presentation/cubits/doctor_states.dart';
import '../cubits/appointment_cubit.dart';

class AppointmentFormSheet extends StatefulWidget {
  const AppointmentFormSheet({super.key});

  @override
  State<AppointmentFormSheet> createState() => _AppointmentFormSheetState();
}

class _AppointmentFormSheetState extends State<AppointmentFormSheet> {
  int? selectedDoctorId;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
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

          BlocBuilder<DoctorCubit, DoctorsStates>(
            builder: (context, state) {
              if (state is DoctorsLoaded) {
                if (state.doctors.isEmpty) {
                  return Center(
                    child: const Text(
                      'There is No Doctors Available',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Select doctor',
                          border: OutlineInputBorder(),
                        ),
                        items: state.doctors
                            .map(
                              (doctor) => DropdownMenuItem<int>(
                                value: doctor.id,
                                child: Text(
                                  '${doctor.fullName} • ${doctor.specialization}',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDoctorId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      /// Date Picker
                      InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
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
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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
                          child: Text(selectedTime.format(context)),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final dateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );

                            final success =
                                await BlocProvider.of<AppointmentCubit>(
                                  context,
                                ).bookAppointment(
                                  doctorId: selectedDoctorId!,
                                  appointmentDate: dateTime,
                                );

                            if (!mounted) return;

                            if (success) {
                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Appointment booked successfully.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Book appointment'),
                        ),
                      ),
                    ],
                  );
                }
              }

              if (state is DoctorsFailed) {
                return Center(
                  child: const Text(
                    'Failed to load doctors',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
