import 'package:flutter/material.dart';

extension IntExtension on double{
  double validate ({double value = 0}){
    return this;
  }

Widget get kH => SizedBox(
  height: this..toDouble(),
);

Widget get kW => SizedBox(
  width: this..toDouble(),
);
}