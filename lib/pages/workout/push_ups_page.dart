import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_colors.dart';

class PushUpsPage extends StatelessWidget {
  const PushUpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: Text('PushUps', style: TextStyle(color: AppColors.yellow),),),
    );
  }
}
