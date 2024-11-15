import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/show_user/view/widget/main_widget/show_user_widget.dart';

class ShowUserPage extends StatelessWidget {
  const ShowUserPage({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
          bottom: false,
          child: ShowUserWidget(
            id: id,
          )),
    );
  }
}
