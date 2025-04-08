import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_theme.dart';

void toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(
        bottom: 54,
        left: 40,
        right: 40,
      ),
      // duration: Duration(
      //   milliseconds: 2000,
      // ),
      dismissDirection: DismissDirection.startToEnd,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTheme.description.copyWith(
          color: AppTheme.yellow,
        ),
      ),
      backgroundColor: AppTheme.white.withAlpha(50),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    ),
  );
}
