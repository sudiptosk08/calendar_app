// lib/providers/appointment_provider.dart

import 'package:calendar_app/model/appoinment_model.dart';
import 'package:flutter/material.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  List<Appointment> getAppointmentsForDay(DateTime day) {
    return _appointments
        .where((appointment) => appointment.date == day)
        .toList();
  }
}
