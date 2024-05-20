// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/common/base/ok_dialog.dart';
import 'package:personal_trainer_app/domain/entity/trainer.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/training/util/start_training_controller.dart';
import 'package:wakelock/wakelock.dart';

class StartTrainingPage extends StatefulWidget {
  final Training training;
  final Duration restTime;

  const StartTrainingPage({
    super.key,
    required this.training,
    required this.restTime,
  });

  @override
  State<StartTrainingPage> createState() => _StartTrainingPageState();
}

class _StartTrainingPageState extends State<StartTrainingPage>
    with StartTrainingController {
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  void canPop(BuildContext context, {bool? isSuccess}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.pop(isSuccess);
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = currentTime();
    final message = isWorkNow ? "Работаем!" : "Отдых";
    final titleButton = isWorkNow ? 'Отдых' : 'Поехали';
    final bgColor = isWorkNow ? Colors.red : Colors.green;

    return WillPopScope(
      onWillPop: () {
        if (!isFinishState) {
          showOkDialog(context,
                  title: 'Тренировка не завершена!',
                  description: ' При выходе прогресс будет потерян!')
              .then((value) {
            if (value != null && value == true) {
              canPop(context);
            }
          });
        }

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppTheme.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppTheme.white,
            ),
            onPressed: () {
              if (isFinishState) {
                context.pop(true);
              } else {
                showOkDialog(context,
                        title: 'Тренировка не завершена!',
                        description: ' При выходе прогресс будет потерян!')
                    .then((value) {
                  if (value != null && value == true) {
                    canPop(context);
                  }
                });
              }
            },
          ),
        ),
        body: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    message,
                    style: TextStyle(fontSize: 44, color: bgColor),
                  ),
                  ListSteps(
                    steps: training.pushUpsCount,
                    currentIndex: currentIndex,
                  ),
                  const Spacer(),
                  Visibility(
                    visible: time != null,
                    maintainState: true,
                    maintainSize: true,
                    maintainAnimation: true,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          time ?? '',
                          style: AppTheme.trainingTimer,
                        ),
                        SizedBox(
                          height: 90,
                          width: 130,
                          child: CircularProgressIndicator(
                            value: getPercentTime(),
                            strokeWidth: 8,
                            color: bgColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: IgnorePointer(
                      ignoring: isFinishState,
                      child: Opacity(
                        opacity: isFinishState ? .2 : 1,
                        child: OutlinedButton(
                          onPressed: onTapAction,
                          child: Text(
                            titleButton,
                            style: AppTheme.trainingButtonTextStyle,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onSuccess() {
    showOkDialog(context,
            title: 'Тренировка завершена',
            description: 'Данные успешно сохранены!',
            showCancel: false)
        .then((value) {
      context.pop(StatisticTraining(
        startDate: _startDate,
        finishDate: DateTime.now(),
      ));
    });
  }

  @override
  Training get training => widget.training;

  @override
  Duration get restDuration => widget.restTime;
}

class ListSteps extends StatelessWidget {
  final List<int> steps;
  final int currentIndex;

  const ListSteps({
    super.key,
    required this.steps,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...steps.indexed.map((e) {
                final isSelected = currentIndex == e.$1;
                final fontSize = isSelected ? 44.0 : 32.0;
                final textColor = isSelected
                    ? Colors.blue
                    : e.$1 < currentIndex
                        ? Colors.lightGreen
                        : Colors.red;

                return Padding(
                  padding: EdgeInsets.only(
                    right: e.$1 < steps.length - 1 ? 8 : 0,
                    top: isSelected ? 24 : 0,
                  ),
                  child: Text(
                    '${e.$2}',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                    ),
                  ),
                );
              })
            ],
          ),
        )
      ],
    );
  }
}
