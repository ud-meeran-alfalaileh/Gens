import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class DateTimeRangePickerPage extends StatefulWidget {
  @override
  _DateTimeRangePickerPageState createState() => _DateTimeRangePickerPageState();
}

class _DateTimeRangePickerPageState extends State<DateTimeRangePickerPage> {
  DateTimeRange? _dateRange;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  
  // Restricted days (5 = Friday, 7 = Sunday)
  final List<int> _restrictedDays = [5, 7];

  // Doctor's working hours (10 AM - 5 PM)
  final TimeOfDay _workStart = TimeOfDay(hour: 10, minute: 0);
  final TimeOfDay _workEnd = TimeOfDay(hour: 17, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date and Time Range'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text(
                _dateRange == null
                    ? 'Select Date Range'
                    : '${_dateFormatter.format(_dateRange!.start)} - ${_dateFormatter.format(_dateRange!.end)}',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectStartTime(context),
              child: Text(
                _startTime == null
                    ? 'Select Start Time'
                    : 'Start Time: ${_startTime!.format(context)}',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectEndTime(context),
              child: Text(
                _endTime == null
                    ? 'Select End Time'
                    : 'End Time: ${_endTime!.format(context)}',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _printSelections,
              child: Text('Print Selections'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
      
      // Check if any restricted days are in the range
      if (_containsRestrictedDays(picked)) {
        _showRestrictedDaysWarning(context);
      }
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // Set the minutes to 00 and notify the user if the selected time is outside working hours
      picked = picked.replacing(minute: 0);

      setState(() {
        _startTime = picked;
      });

      if (!_isWithinWorkingHours(picked)) {
        _showTimeWarning(context);
      }
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // Set the minutes to 00 and notify the user if the selected time is outside working hours
      picked = picked.replacing(minute: 0);

      setState(() {
        _endTime = picked;
      });

      if (!_isWithinWorkingHours(picked)) {
        _showTimeWarning(context);
      }
    }
  }

  void _printSelections() {
    if (_dateRange == null || _startTime == null || _endTime == null) {
      print('Please select both date and time range.');
      return;
    }

    String startDate = _dateFormatter.format(_dateRange!.start);
    String endDate = _dateFormatter.format(_dateRange!.end);
    String startTime = _startTime!.format(context);
    String endTime = _endTime!.format(context);

    print('Selected Date Range: $startDate to $endDate');
    print('Selected Time Range: $startTime to $endTime');
  }

  // Check if the selected date range contains restricted days (Friday, Sunday)
  bool _containsRestrictedDays(DateTimeRange range) {
    for (int i = 0; i <= range.end.difference(range.start).inDays; i++) {
      DateTime day = range.start.add(Duration(days: i));
      if (_restrictedDays.contains(day.weekday)) {
        return true; // Found a restricted day
      }
    }
    return false; // No restricted days found
  }

  // Show a warning dialog if restricted days are selected
  void _showRestrictedDaysWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notice"),
          content: Text("The selected date range includes Friday or Sunday. Please note that the doctor does not work on these days."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Check if the selected time is within the doctor's working hours (10:00 AM to 5:00 PM)
  bool _isWithinWorkingHours(TimeOfDay selectedTime) {
    final selected = _timeOfDayToDouble(selectedTime);
    final workStart = _timeOfDayToDouble(_workStart);
    final workEnd = _timeOfDayToDouble(_workEnd);
    
    return selected >= workStart && selected <= workEnd;
  }

  // Show a warning if the selected time is outside of working hours
  void _showTimeWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notice"),
          content: Text("The selected time is outside of the doctor's working hours (10:00 AM - 5:00 PM)."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Convert TimeOfDay to a double for easier comparison
  double _timeOfDayToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }
}

void main() {
  runApp(MaterialApp(home: DateTimeRangePickerPage()));
}
