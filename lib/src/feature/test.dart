// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Table Calendar Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: CalendarScreen(),
//     );
//   }
// }

// class CalendarScreen extends StatefulWidget {
//   @override
//   _CalendarScreenState createState() => _CalendarScreenState();
// }

// class _CalendarScreenState extends State<CalendarScreen> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   final Rx<DateTime> _focusedDay = DateTime.now().obs;
//   final Rx<DateTime?> _selectedDay = Rx<DateTime?>(null);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Table Calendar Example'),
//       ),
//       body: Column(
//         children: [
//           Obx(
//             () => TableCalendar(
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: _focusedDay.value,
//               calendarFormat: _calendarFormat,
//               selectedDayPredicate: (day) {
//                 return isSameDay(_selectedDay.value, day);
//               },
//               onDaySelected: (selectedDay, focusedDay) {
//                 _selectedDay.value = selectedDay;
//                 _focusedDay.value = focusedDay;
//                 print(_focusedDay.value);
//               },
//               onFormatChanged: (format) {
//                 if (_calendarFormat != format) {
//                   _calendarFormat = format;
//                 }
//               },
//               onPageChanged: (focusedDay) {
//                 _focusedDay.value = focusedDay;
//               },
//             ),
//           ),
//           SizedBox(height: 8.0),
//           if (_selectedDay.value != null)
//             Obx(
//               () => Text(
//                 'Selected day: ${DateFormat.yMMMMd().format(_selectedDay.value!)}',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
