import 'package:connectivity_plus/connectivity_plus.dart'; // Import for connectivity check
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:get/get.dart';

class ConnectionLostScreen extends StatelessWidget {
  final bool isConnected;

  const ConnectionLostScreen({super.key, required this.isConnected});

  @override
  Widget build(context) {
    if (isConnected) return SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: context.screenWidth * .3,
                height: context.screenHeight * .2,
                child: loadingPage(context),
              ),
              SizedBox(height: 20),
              Text(
                'Looks like you have no internet connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Alexandria",
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightAppColors.primary),
              ),
              20.0.kH,
              GestureDetector(
                onTap: () async {
                  // Check for internet connection
                  List<ConnectivityResult> result =
                      await Connectivity().checkConnectivity();
                  // ignore: unrelated_type_equality_checks
                  if (result.first != ConnectivityResult.none) {
                     
                    Phoenix.rebirth(context);
                  } else {
                    // If not connected, show a message or do nothing
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppTheme.lightAppColors.primary.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Reload".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Alexandria",
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightAppColors.background),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
