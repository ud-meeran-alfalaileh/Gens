import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/waiting_list/view/widget/main_widget/waiting_list_widget.dart';

class WaitingListPage extends StatelessWidget {
  const WaitingListPage(
      {super.key,
       
      required this.vendorId,
      required this.serviceId,
      required this.vendorPhone});
  final int vendorId;
  final int serviceId;

 
  final String vendorPhone;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: WaitingListWidget(
   
      
        vendorId: vendorId,
        serviceId: serviceId,
        vendorPhone: vendorPhone.toString(),
      ),
    );
  }
}
