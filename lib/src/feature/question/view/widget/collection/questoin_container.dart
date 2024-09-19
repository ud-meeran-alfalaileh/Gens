import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';

class QuestionCard extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final void Function(String?)? onRadioChanged;
  final void Function(bool?)? onCheckboxChanged;
  final bool isSingleChoice;

  QuestionCard({
    required this.answer,
    required this.isSelected,
    this.onRadioChanged,
    this.onCheckboxChanged,
    required this.isSingleChoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: context.screenWidth,
      height: context.screenHeight * .08,
      decoration: BoxDecoration(
        color: AppTheme.lightAppColors.maincolor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(answer),
          isSingleChoice
              ? Radio<String>(
                  focusColor: AppTheme.lightAppColors.primary,
                  activeColor: AppTheme.lightAppColors.primary,
                  value: answer,
                  groupValue: isSelected ? answer : null,
                  onChanged: onRadioChanged,
                )
              : Checkbox(
                  checkColor: Colors.white,
                  activeColor: AppTheme.lightAppColors.primary,
                  value: isSelected,
                  onChanged: onCheckboxChanged,
                ),
        ],
      ),
    );
  }
}
