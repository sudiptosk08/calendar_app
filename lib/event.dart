import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TableEventsExample(),
    );
  }
}

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar - Events'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              weekNumbersVisible: true,
              startingDayOfWeek: StartingDayOfWeek.monday,

              calendarStyle: const CalendarStyle(
                  isTodayHighlighted: false,
                  selectedTextStyle: const TextStyle(color: Colors.black),
                  cellAlignment: Alignment.topCenter,
                  markersMaxCount: 60),

              daysOfWeekVisible: true,
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              headerVisible: true,

              // simpleSwipeConfig: ,

              daysOfWeekHeight: 90,
              rowHeight: 400,
              availableGestures: AvailableGestures.none,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: events
                            .take(10) // Limit to show only first 3 events
                            .map((event) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 1.5),
                                  width: 208.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Text('${event.title}'),
                                ))
                            .toList(),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
                dowBuilder: (context, day) {
                  return Center(
                    child: Text(
                      DateFormat.E().format(day),
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  );
                },
                headerTitleBuilder: (context, day) {
                  return Center(
                    child: Text(
                      DateFormat.yMMMM().format(day),
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(60, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
};

int getHashCode(DateTime key) {
  return key.day * 100 + key.month * 1000 + key.year;
}

Iterable<DateTime> daysInRange(DateTime first, DateTime last) sync* {
  var i = first;
  final dateCount = last.difference(first).inDays + 1;
  for (int i = 0; i < dateCount; i++) {
    yield DateTime(first.year, first.month, first.day + i);
  }
}
