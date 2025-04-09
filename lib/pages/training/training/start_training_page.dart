// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/common/base/ok_dialog.dart';
import 'package:personal_trainer_app/domain/entity/trainer.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/training/util/start_training_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
  late var canPop = isFinishState;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = currentTime();
    final message = isWorkNow ? "Работаем!" : "Отдых";
    final titleButton = isWorkNow ? 'Отдых' : 'Поехали';
    final bgColor = isWorkNow ? Colors.red : Colors.green;

    return WillPopScope(
      onWillPop: () {
        if (!canPop) {
          showOkDialog(context,
                  title: 'Тренировка не завершена!',
                  description: ' При выходе прогресс будет потерян!')
              .then((value) {
            if (value == true && context.mounted) {
              canPop = true;
              context.pop();
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
            onPressed: context.pop,
          ),
        ),
        body: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  ListSteps(
                    steps: training.pushUpsCount,
                    currentIndex: currentIndex,
                  ),
                  const Spacer(),
                  _TextAnimatedWidget(
                    child: Text(
                      message,
                      key: ValueKey(message),
                      style: TextStyle(fontSize: 44, color: bgColor),
                    ),
                  ),
                  const Spacer(),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: time != null ? 1 : 0,
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
      final cContext = context;
      if (cContext.mounted) {
        canPop = true;
        cContext.pop(StatisticTraining(
          startDate: _startDate,
          finishDate: DateTime.now(),
        ));
      }
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Верхняя выбранная цифра
        _TextAnimatedWidget(
          child: Text(
            steps[currentIndex].toString(),
            key: ValueKey(currentIndex),
            style: TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 16),
        // Горизонтальный список цифр
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...steps.indexed.map((e) {
              final isSelected = currentIndex == e.$1;
              final fontSize = isSelected ? 32.0 : 24.0;
              final textColor = isSelected
                  ? Colors.blue
                  : e.$1 < currentIndex
                      ? Colors.lightGreen
                      : Colors.red;

              return AnimatedPadding(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.only(
                  right: e.$1 < steps.length - 1 ? 8 : 0,
                  top: isSelected ? 8 : 0,
                ),
                child: Opacity(
                  opacity: isSelected
                      ? 0.5
                      : 1.0, // сделаем выбранный бледнее в списке
                  child: Text(
                    '${e.$2}',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ],
    );
  }
}

class _TextAnimatedWidget extends StatelessWidget {
  const _TextAnimatedWidget({
    required this.child,
  });

  // final List<int> steps;
  // final int currentIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
