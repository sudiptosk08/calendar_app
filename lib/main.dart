import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Getting Started',
      home: Scaffold(
        body: SfCalendar(
          view: CalendarView.month,

          allowAppointmentResize: true,
          // allowViewNavigation: true,

          dataSource: MeetingDataSource(_getDataSource()),
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayCount: 30,
              showAgenda: false,
              numberOfWeeksInView: 2,
              navigationDirection: MonthNavigationDirection.vertical,
              monthCellStyle: MonthCellStyle(
                todayBackgroundColor: Colors.amber,
              ),
              showTrailingAndLeadingDates: true,
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(Duration(hours: 2));
    meetings.add(
      Meeting("Conference", startTime, endTime, Color(0xFF0F8644), false),
    );
    meetings.add(
      Meeting("Sex Time", startTime, endTime, Color.fromARGB(255, 15, 72, 134),
          false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );
    meetings.add(
      Meeting("Movie ", startTime, endTime, Color.fromARGB(255, 134, 43, 15),
          false),
    );
    meetings.add(
      Meeting("Sex Time", startTime, endTime, Color.fromARGB(255, 15, 72, 134),
          false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );
    meetings.add(
      Meeting("Conference", startTime, endTime, Color(0xFF0F8644), false),
    );
    meetings.add(
      Meeting("Movie ", startTime, endTime, Color.fromARGB(255, 134, 43, 15),
          false),
    );
    meetings.add(
      Meeting("Sex Time", startTime, endTime, Color.fromARGB(255, 15, 72, 134),
          false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );
    meetings.add(
      Meeting("Conference", startTime, endTime, Color(0xFF0F8644), false),
    );
    meetings.add(
      Meeting("Movie ", startTime, endTime, Color.fromARGB(255, 134, 43, 15),
          false),
    );
    meetings.add(
      Meeting("Sex Time", startTime, endTime, Color.fromARGB(255, 15, 72, 134),
          false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );
    meetings.add(
      Meeting("Movie ", startTime, endTime, Color.fromARGB(255, 134, 43, 15),
          false),
    );
    meetings.add(
      Meeting("Sex Time", startTime, endTime, Color.fromARGB(255, 15, 72, 134),
          false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );
    meetings.add(
      Meeting("Conference", startTime, endTime, Color(0xFF0F8644), false),
    );
    meetings.add(
      Meeting("Movie ", startTime, endTime, Color.fromARGB(255, 134, 43, 15),
          false),
    );
    meetings.add(
      Meeting("Sex Time", startTime, endTime, Color.fromARGB(255, 15, 72, 134),
          false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );
    meetings.add(
      Meeting("Conference", startTime, endTime, Color(0xFF0F8644), false),
    );
    meetings.add(
      Meeting("Movie ", startTime, endTime, Color.fromARGB(255, 134, 43, 15),
          false),
    );
    meetings.add(
      Meeting("Sex Time", startTime, endTime, Color.fromARGB(255, 15, 72, 134),
          false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );
    meetings.add(
      Meeting("Conference", startTime, endTime, Color(0xFF0F8644), false),
    );
    meetings.add(
      Meeting("Movie ", startTime, endTime, Color.fromARGB(255, 134, 43, 15),
          false),
    );
    meetings.add(
      Meeting("Sex Time", startTime, endTime, Color.fromARGB(255, 15, 72, 134),
          false),
    );
    meetings.add(
      Meeting("Love Time", startTime, endTime,
          Color.fromARGB(255, 134, 110, 15), false),
    );

    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
