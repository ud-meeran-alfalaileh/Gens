import 'package:calendar_view/calendar_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gens/src/config/localization/local_strings.dart';
import 'package:gens/src/config/localization/locale_constant.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/injection_container.dart' as di;
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/connection_lost_screen.dart';
import 'package:gens/src/feature/history/view/page/user_waiting_list.dart';
import 'package:gens/src/feature/nav_bar/view/main/main_app_page.dart';
import 'package:gens/src/feature/nav_bar/view/main/navbar_page.dart';
import 'package:gens/src/feature/waiting_list/view/page/vendor_waiting_list.dart';
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
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final navigatorKey = GlobalKey<NavigatorState>();

  User user = User();

  late OverlayEntry _overlayEntry;
  final RxBool _isConnected = true.obs;
  @override
  void initState() {
    super.initState();
    initst();

    _overlayEntry = _createOverlayEntry();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        // Get the last connectivity result in the list
        ConnectivityResult result = results.last;

        bool connected = result != ConnectivityResult.none;

        // Only update the overlay if the connection state changes
        if (_isConnected.value != connected) {
          setState(() {
            _isConnected.value = connected;
            _updateOverlay();
          });
        }
      });
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) =>
          ConnectionLostScreen(isConnected: _isConnected.value),
    );
  }

  void _updateOverlay() {
    if (!_isConnected.value) {
      // Insert the overlay only if it's not already in the overlay.
      if (!_overlayEntry.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.overlay?.insert(_overlayEntry);
        });
      }
    } else {
      // Remove the overlay if it is mounted and re-create it.
      if (_overlayEntry.mounted) {
        _overlayEntry.remove();
        _overlayEntry = _createOverlayEntry();
        Phoenix.rebirth(context);
      }
    }
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
    bool hasNavigated = false;

    OneSignal.Notifications.addClickListener((notification) {
      if (!hasNavigated) {
        hasNavigated = true;

        // Extract additionalData from the notification
        Map<String, dynamic>? additionalData =
            notification.notification.additionalData;

        // Check if 'route' is available in additionalData
        if (additionalData != null && additionalData.containsKey('route')) {
          String? route = additionalData['route'];
          print(route);
          if (route != null) {
            // Navigate to the specified route
            navigatorKey.currentState?.pushNamed("/$route");
          }
        } else {}
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
          "/NavBarPage": (context) => const NavBarPage(
                currentScreen: 1,
              ),
          "/waiting": (context) => const UserWaitingListPage(),
          "/NavBarPageI": (context) => const NavBarPage(
                currentScreen: 0,
              ),
          "/NavBarPageC": (context) => const NavBarPage(
                currentScreen: 2,
              ),
          "/vendorNav": (context) => const NavBarPage(
                currentScreen: 0,
              ),
          "/vendorWaitingList": (context) => const VendorWaitingList(),
          "/vendorNavBarCalendar": (context) => const NavBarPage(
                currentScreen: 1,
              ),
          // "/NavBarPage": (context) => const ProfilePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
