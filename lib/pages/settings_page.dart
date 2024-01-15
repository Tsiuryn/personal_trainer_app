import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text('Settings', style: TextStyle(color: AppColors.yellow),),),
    );
  }
}
