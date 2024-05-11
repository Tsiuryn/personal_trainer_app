import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_theme.dart';

class AbTrainPage extends StatelessWidget {
  const AbTrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'AbTrainPage',
          style: TextStyle(color: AppTheme.yellow),
        ),
      ),
    );
  }
}
