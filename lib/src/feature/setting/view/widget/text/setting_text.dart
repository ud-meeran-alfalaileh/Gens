import 'package:flutter/material.dart';

class SettingText {
  static settingbuttonText(title, color) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        color: color,
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
