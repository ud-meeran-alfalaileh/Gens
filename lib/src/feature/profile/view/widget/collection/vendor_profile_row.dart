import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';

class VendorProfileRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const VendorProfileRow(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? AppTheme.lightAppColors.background
              : const Color(0xfff5f5f5),
        ),
        child: ProfileText.containerText(title, isSelected),
      ),
    );
  }
}
