import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/history/view/widget/main_widget/user_waiting_list_widget.dart';

class UserWaitingListPage extends StatelessWidget {
  const UserWaitingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: const UserWaitingListWidget(),
    );
  }
}
