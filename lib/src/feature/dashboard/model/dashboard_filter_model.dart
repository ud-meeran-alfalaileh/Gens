import 'package:flutter/material.dart';

class DashboardFilterModel {
  String title;
  VoidCallback onTap;
  bool isSelected;

  DashboardFilterModel(
      {required this.onTap, required this.isSelected, required this.title});
}
