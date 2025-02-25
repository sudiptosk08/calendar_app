import 'dart:collection';
import 'package:calendar_app/model/events_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TableEventsCalendar extends StatefulWidget {
  const TableEventsCalendar({super.key});

  @override
  _TableEventsCalendarState createState() => _TableEventsCalendarState();
}

class _TableEventsCalendarState extends State<TableEventsCalendar> {
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
    _selectedEvents = ValueNotifier([]);

    _fetchEventsFromFirestore();
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

  void _addEvent(Event event) async {
    final docRef = await FirebaseFirestore.instance
        .collection('events')
        .add(event.toFirestore());
    final newEvent = Event(id: docRef.id, title: event.title, date: event.date);

    if (_selectedDay != null) {
      setState(() {
        final events = _getEventsForDay(_selectedDay!);
        events.add(newEvent);
        kEvents[_selectedDay!] = events;
        _selectedEvents.value = events;
      });
    }
  }

  void _showAddEventDialog() {
    final TextEditingController eventController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: TextField(
          controller: eventController,
          decoration: const InputDecoration(hintText: 'Event Title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final event = Event(
                id: '',
                title: eventController.text,
                date: _selectedDay!,
              );
              _addEvent(event);
              Navigator.pop(context);
            },
            child: const Text('Add Event'),
          ),
        ],
      ),
    );
  }

  void _fetchEventsFromFirestore() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('events').get();
    final events = snapshot.docs.map((doc) {
      return Event.fromFirestore(doc);
    }).toList();

    setState(() {
      for (var event in events) {
        final date = event.date;
        if (kEvents[date] == null) {
          kEvents[date] = [];
        }
        kEvents[date]!.add(event);
      }
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              weekNumbersVisible: false,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),
              calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 174, 207, 227),
                  ),
                  isTodayHighlighted: false,
                  todayDecoration:
                      BoxDecoration(color: Color.fromARGB(255, 186, 206, 239)),
                  selectedTextStyle: TextStyle(color: Colors.black),
                  cellPadding: EdgeInsets.zero,
                  cellMargin: EdgeInsets.zero,
                  cellAlignment: Alignment.topCenter,
                  canMarkersOverflow: false,
                  tableBorder: TableBorder(
                    verticalInside: BorderSide(color: Colors.blueGrey),
                    horizontalInside: BorderSide(color: Colors.blueGrey),
                    top: BorderSide(color: Colors.blueGrey),
                    bottom: BorderSide(color: Colors.blueGrey),
                  ),
                  markersMaxCount: 60),
              daysOfWeekVisible: true,
              daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              headerVisible: true,
              daysOfWeekHeight: 90,
              rowHeight: 450,
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
                      top: 30,
                      left: 1,
                      child: Column(
                        verticalDirection: VerticalDirection.down,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: events
                            .take(30) // Limit to show only first 3 events
                            .map((event) => Padding(
                                  padding: const EdgeInsets.only(bottom: 1.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Text(
                                      event.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  }
                  return const SizedBox.expand();
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
            const SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 90),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              onPressed: _showAddEventDialog,
              child: const Text('Add Event'),
            ),
            ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(value[index].title),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

final kFirstDay = DateTime(2021, 1, 1);
final kLastDay = DateTime(2031, 12, 31);

final kToday = DateTime.now();

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

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
