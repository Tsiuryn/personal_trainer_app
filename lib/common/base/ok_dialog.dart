import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/main.dart';

Future<bool?> showOkDialog(
  BuildContext context, {
  required String title,
  String? description,
  bool showCancel = true,
}) async {
  return showCupertinoDialog<bool?>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: description == null ? null : Text(description),
          actions: [
            if (showCancel)
              CupertinoDialogAction(
                child: Text(
                  'Отмена',
                  style: TextStyle(color: AppTheme.black),
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            CupertinoDialogAction(
              child: Text(
                'Ok',
                style: TextStyle(color: AppTheme.red),
              ),
              onPressed: () {
                context.pop(true);
              },
            )
          ],
        );
      });
}
