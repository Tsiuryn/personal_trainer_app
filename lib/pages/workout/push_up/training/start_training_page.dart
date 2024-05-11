import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/domain/entity/push_up/trainer.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/workout/push_up/util/start_training_controller.dart';

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

class _StartTrainingPageState extends State<StartTrainingPage> with StartTrainingController {
  Future<T?> _showDialog<T>({
    bool isPop = false,
  }) async {
    final title = isPop
        ? 'Тренировка не завершена. При выходе прогресс будет потерян!'
        : 'Тренировка успешно завершена!';
    const style = TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

    return showDialog<T>(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            actions: [
              if (isPop)
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    'Отмена',
                    style: style.copyWith(color: Colors.green),
                  ),
                ),
              if (isPop)
                TextButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    child: const Text(
                      'Выйти',
                      style: style,
                    )),
              if (!isPop)
                TextButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    child: const Text(
                      'Ok',
                      style: style,
                    ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final time = currentTime();
    final message = isWorkNow ? "Работаем!" : "Отдых";
    final titleButton =
        isWorkNow ? 'Отдых' : 'Поехали';
    final bgColor =
        isWorkNow ? Colors.red : Colors.green;

    return PopScope(
      onPopInvoked: (_) {
        if (!isFinishState) {
          _showDialog(
            isPop: true,
          ).then((value) {
            if (value != null && value == true) {
              context.pop();
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.white,),
            onPressed: () {
              if (isFinishState) {
                context.pop(true);
              } else {
                _showDialog(
                  isPop: true,
                ).then((value) {
                  if (value != null && value == true) {
                    context.pop();
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
                        opacity:
                            isFinishState ? .2 : 1,
                        child: OutlinedButton(
                          onPressed: onTapAction,
                          child: Text(titleButton, style: AppTheme.trainingButtonTextStyle,),
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
    _showDialog().then((value) {
      context.pop(true);
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
