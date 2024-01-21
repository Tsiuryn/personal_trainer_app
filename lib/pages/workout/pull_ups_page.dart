import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_colors.dart';

class PullUpsPage extends StatelessWidget {
  const PullUpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'PullUps',
          style: TextStyle(color: AppColors.yellow),
        ),
      ),
    );
  }
}
