import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyAppointments extends StatefulWidget {
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final DateTime _firstDay = DateTime.utc(2020, 1, 1);
  final DateTime _lastDay = DateTime.utc(2030, 12, 31);

  final Map<DateTime, List<Map<String, String>>> _events = {};

  int _selectedIndex = 1;

  void _onBottomNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'home');
        break;
      case 1:
      // Current page
        break;
      case 2:
        Navigator.pushNamed(context, 'profile');
        break;
    }
  }

  void _addEvent(DateTime day, String description, String time) {
    setState(() {
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add({
        'description': description,
        'time': time,
      });
    });
  }

  void _deleteEvent(DateTime day, int index) {
    setState(() {
      if (_events[day] != null) {
        _events[day]!.removeAt(index);
        if (_events[day]!.isEmpty) {
          _events.remove(day);
        }
      }
    });
  }

  Future<void> _selectTime(BuildContext context, TextEditingController timeController) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      timeController.text = '${selectedTime.format(context)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> selectedDayEvents = _events[_selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              firstDay: _firstDay,
              lastDay: _lastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              eventLoader: (day) => _events[day] ?? [],
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointment Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ...selectedDayEvents.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> event = entry.value;
                    return ListTile(
                      title: Text('${event['description']}'),
                      subtitle: Text('${event['time']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvent(_selectedDay, index),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showAddEventDialog();
                    },
                    child: Text('Add Event'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavBarItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _showAddEventDialog() {
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: 'Event description'),
              ),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(hintText: 'Event time'),
                readOnly: true,
                onTap: () => _selectTime(context, _timeController),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_descriptionController.text.isNotEmpty && _timeController.text.isNotEmpty) {
                  _addEvent(_selectedDay, _descriptionController.text, _timeController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
