// import 'package:calendar_view/calendar_view.dart';
// import 'package:flutter/material.dart';
// import 'package:gens/src/feature/calendar/controller/calender_controller.dart';
// import 'package:get/get.dart';

// class CalendarWidget extends StatefulWidget {
//   const CalendarWidget({super.key});

//   @override
//   State<CalendarWidget> createState() => _CalendarWidgetState();
// }

// class _CalendarWidgetState extends State<CalendarWidget> {
//   final GlobalKey<DayViewState> dayViewKey = GlobalKey<DayViewState>();
//   final CalenderControllerr controller = Get.put(CalenderControllerr());

//   @override
//   void initState() {
//     super.initState();
//     // Call the method to fetch calendar events when the widget initializes
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     controller.isMonthView.value =
//                         !controller.isMonthView.value;
//                   });
//                 },
//                 icon: Icon(controller.isMonthView.value
//                     ? Icons.calendar_today
//                     : Icons.calendar_month),
//               )
//             ],
//           ),
//           Expanded(
//             child: Obx(() {
//               // Use the observable list of events from the controller
//               final events = controller.event;

//               // Clear previous events in the controller
 
//               // Add events to the controller
//               for (var event in events) {
//                 controller.eventController.add(CalendarEventData(
//                   title: event.description,
//                   description: event.description,
//                   date: event.date,
//                   startTime: event.date,
//                   endTime:
//                       event.date.add(Duration(hours: 1)), // Example duration
//                 ));
//               }

//               if (controller.isMonthView.value) {
//                 return MonthView(
//                   controller: controller.eventController,
//                   onCellTap: (cell, eventArranger) {
//                     // When a day is tapped, switch to DayView
//                     controller.isMonthView.value = false;

//                     // Jump to the selected date in the DayView
//                     dayViewKey.currentState?.jumpToDate(cell.first.date);
//                   },
//                   // You can add the onEventTap here if supported
//                   onEventTap: (event) {
//                     // Show event details in a dialog when tapped
//                     showEventDetails(event.description!, event.title);
//                   },
//                   headerStyle: HeaderStyle(
//                     decoration: BoxDecoration(color: Colors.blue[100]),
//                     titleAlign: TextAlign.center,
//                     headerTextStyle:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                 );
//               } else {
//                 return DayView(
//                   key: dayViewKey,
//                   controller: controller.eventController,
//                   backgroundColor: Colors.white,
//                   headerStyle: HeaderStyle(
//                     decoration: BoxDecoration(color: Colors.blue[100]),
//                     titleAlign: TextAlign.center,
//                     headerTextStyle:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   onDateTap: (date) {
//                     // Handle date tap if needed
//                   },
//                   onEventTap: (event, data) {
//                     // Display event details on tap
//                     showEventDetails(event.first.description!, event.first.title);
//                   },
//                 );
//               }
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   void showEventDetails(
//     String event,
//     String title,
//   ) {
//     // Display a dialog with event details
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Description: $event"),
//               // Additional details can be added here if needed
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Close"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
