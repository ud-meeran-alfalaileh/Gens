import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/config/localization/local_strings.dart';
import 'package:gens/src/config/localization/locale_constant.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/injection_container.dart' as di;
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/nav_bar/view/main/main_app_page.dart';
import 'package:gens/src/feature/nav_bar/view/main/navbar_page.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

final localizationController = Get.put(LocalizationController());

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
  static final navigatorKey = GlobalKey<NavigatorState>();

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
    localizationController.loadLanguage();

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
    String? screen;
    OneSignal.Notifications.addClickListener((value) {
      final data = value.notification.additionalData;
      screen = '/navBar';
      if (screen != null) {
        navigatorKey.currentState?.pushNamed(screen!);
      }
    });

    return CalendarControllerProvider(
      controller: EventController(),
      child: GetMaterialApp(
        title: 'Gens',
        navigatorKey: navigatorKey,
        locale: const Locale('en', 'US'),
        translations: LocalStrings(),
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const MainAppPage(),
          "/navBar": (context) => const NavBarPage(
                currentScreen: 3,
              ),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
