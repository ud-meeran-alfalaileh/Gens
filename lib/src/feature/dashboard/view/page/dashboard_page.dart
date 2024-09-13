import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/main_widget/dashborad_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Container(
        color: AppTheme.lightAppColors.background,
        child: const SafeArea(bottom: false, child: DashboradWidget()),
      ),
    );
  }

  drawerContainer(
      BuildContext context, title, Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: context.screenWidth,
          height: context.screenHeight * .06,
          decoration: BoxDecoration(
              color: AppTheme.lightAppColors.primary.withOpacity(.05),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              icon,
              (context.screenHeight * .02).kW,
              Text(
                title,
                style: TextStyle(
                    color: AppTheme.lightAppColors.black,
                    fontFamily: "Inter",
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }
}
