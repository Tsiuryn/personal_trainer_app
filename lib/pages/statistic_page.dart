import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_colors.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Statistic',
          style: TextStyle(color: AppConst.yellow),
        ),
      ),
    );
  }
}
