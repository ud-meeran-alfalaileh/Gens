import 'package:flutter/material.dart';
import 'package:gens/src/config/localization/local_strings.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/injection_container.dart' as di;
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/main_widget/otp_widget.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    await user.loadToken();
    await user.loadOtp();
    print(user.userId);
    print(user.otpCode);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Gens',
        locale: const Locale('en', 'US'),
        translations: LocalStrings(),
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const OtpWidget());
  }
}
