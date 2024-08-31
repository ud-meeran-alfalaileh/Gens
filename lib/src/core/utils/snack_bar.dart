import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showSnackBar(String message, title, Color backgroundColor) {
  Get.snackbar(
    "",
    "",
    snackPosition: SnackPosition.BOTTOM,
    titleText: Text(
      title,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    ),
    messageText: Text(
      message,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    colorText: Colors.white,
    backgroundColor: backgroundColor,
  );
}

void internetConection(context) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: 'noEnternet'.tr,
    ),
  );
}
