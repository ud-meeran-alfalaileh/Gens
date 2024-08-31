import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';

class CustomNavItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const CustomNavItem(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.isSelected,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 12),
        width: context.screenWidth * 0.2,
        height: context.screenHeight,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightAppColors.background.withOpacity(.2)
              : Colors.transparent,
        ),
        child: Column(
          children: [
            icon,
          ],
        ),
      ),
    );
  }
}
