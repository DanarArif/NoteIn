import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widget/navigation_drawer_widget.dart';



class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  List<String> _reminderTasks = []; // Daftar reminder task
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Reminder'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Reminder Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Menampilkan daftar reminder task
              ListView.builder(
                shrinkWrap: true,
                itemCount: _reminderTasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_reminderTasks[index]),
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                'Add Reminder Task',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Task',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showDateTimePicker,
                child: Text('Set Date and Time'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_taskController.text.isNotEmpty && _selectedDate != null && _selectedTime != null) {
                    setState(() {
                      String taskWithDateTime = '${_taskController.text} - ${DateFormat('dd/MM/yyyy').format(_selectedDate!)} ${_selectedTime!.format(context)}';
                      _reminderTasks.add(taskWithDateTime);
                      _taskController.clear();
                      _selectedDate = null;
                      _selectedTime = null;
                    });
                  }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateTimePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDate = selectedDate;
          _selectedTime = selectedTime;
        });
      }
    }
  }
}
