import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/config/localization/local_strings.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/injection_container.dart' as di;
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/nav_bar/view/main/main_app_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

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
    // await user.clearId();
    // await user.clearVendorId();
    await user.loadOtp();
    await user.loadToken();
    await user.loadVendorId();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Gens',
        locale: const Locale('en', 'US'),
        translations: LocalStrings(),
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const MainAppPage());
  }
}
