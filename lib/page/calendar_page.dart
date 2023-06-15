import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widget/navigation_drawer_widget.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  TextEditingController _eventController = TextEditingController();

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Calendar'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime(2022),
              lastDay: DateTime(2023),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay ?? DateTime.now(), day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
            ),
            SizedBox(height: 16),
            Text(
              'Selected Day: ${_selectedDay.toString()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ..._events[_selectedDay]?.map((event) =>
                ListTile(
                  title: Text(event.toString()),
                )) ??
                [],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showEventDialog,
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Add Event'),
            content: TextField(
              controller: _eventController,
              decoration: InputDecoration(
                labelText: 'Event',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_eventController.text.isEmpty) return;
                  setState(() {

                    _events[_selectedDay]!.add(_eventController.text);
                    _eventController.clear();
                    Navigator.pop(context);
                  });
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  _eventController.clear();
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }
}
