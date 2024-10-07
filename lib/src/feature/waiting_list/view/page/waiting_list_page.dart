import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/waiting_list/view/widget/main_widget/waiting_list_widget.dart';

class WaitingListPage extends StatelessWidget {
  const WaitingListPage(
      {super.key, required this.dayOfTheWeek, required this.data,required this.vendorId,required this.serviceId});
  final int vendorId;
  final int serviceId;

  final String dayOfTheWeek;
  final String data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body:  WaitingListWidget(dayOfTheWeek: dayOfTheWeek, data: data, vendorId: vendorId, serviceId: serviceId,),
    );
  }
}
