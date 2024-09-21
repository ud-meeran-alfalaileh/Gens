import 'package:flutter/material.dart';
import 'package:gens/src/feature/profile/view/widget/main_widget/profile_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: const ProfileWidget(),
    );
  }
}
