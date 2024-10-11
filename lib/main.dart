import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/config/localization/local_strings.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/injection_container.dart' as di;
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/nav_bar/view/main/main_app_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  OneSignal.initialize("6f187321-1c40-45f0-8ae2-b42038185dae");
  OneSignal.Notifications.requestPermission(true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User user = User();
  @override
  void initState() {
    initst();
    super.initState();
  }

  Future<void> initst() async {
    await requestPermissions();

    // await user.clearId();
    // await user.clearVendorId();
    await user.loadOtp();

    await user.loadToken();
    await user.loadVendorId();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }

    // Handle permission denied scenario
    if (status.isDenied || storageStatus.isDenied) {
      // Handle the case when permission is denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: GetMaterialApp(
          title: 'Gens',
          locale: const Locale('en', 'US'),
          translations: LocalStrings(),
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          home: const MainAppPage()),
    );
  }
}
