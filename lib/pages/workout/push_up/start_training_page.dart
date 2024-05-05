import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/workout/push_up/util/start_training_controller.dart';

class StartTrainingPage extends StatefulWidget {
  final Training training;

  const StartTrainingPage({
    super.key,
    required this.training,
  });

  @override
  State<StartTrainingPage> createState() => _StartTrainingPageState();
}

class _StartTrainingPageState extends State<StartTrainingPage> {
  late StartTrainingController _startTrainingController;

  @override
  void initState() {
    super.initState();
    _startTrainingController = StartTrainingController(
      this,
      training: widget.training,
      onSuccess: (){
        _showDialog().then((value) {
            _startTrainingController.dispose();
            context.pop(true);
        });
      },
    );
  }

  Future<T?> _showDialog<T>({
    bool isPop = false,
  }) async{
    final title = isPop
        ? 'Тренировка не завершена. При выходе прогресс будет потерян!'
        : 'Тренировка успешно завершена!';
    return showDialog(
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
                    child: const Text('Отмена')),
              if (isPop)
                TextButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    child: const Text('Выйти')),
              if (!isPop)
                TextButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    child: const Text('Ok'))
            ],
          );
        });
  }

  @override
  void dispose() {
    _startTrainingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = _startTrainingController.currentTime();
    final message = _startTrainingController.isWorkNow ? "Работаем!" : "Отдых";
    final titleButton =
        _startTrainingController.isWorkNow ? 'Отдых' : 'Поехали';
    final bgColor =
        _startTrainingController.isWorkNow ? Colors.red : Colors.green;

    return PopScope(
      onPopInvoked: (_) {
        if (!_startTrainingController.isFinishState) {
          _showDialog(
            isPop: true,).then((value) {
            if(value != null && value == true){
              context.pop();
            }
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_startTrainingController.isFinishState) {
                context.pop(true);
              } else {
                _showDialog(
                  isPop: true,).then((value) {
                  if(value != null && value == true){
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
                    steps: _startTrainingController.training.pushUpsCount,
                    currentIndex: _startTrainingController.currentIndex,
                  ),
                  Spacer(),
                  Visibility(
                    visible: currentTime != null,
                    maintainState: true,
                    maintainSize: true,
                    maintainAnimation: true,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          currentTime ?? '',
                          style: const TextStyle(
                              fontSize: 44, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 90,
                          width: 130,
                          child: CircularProgressIndicator(
                            value: _startTrainingController.getPercentTime(),
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
                      ignoring: _startTrainingController.isFinishState,
                      child: Opacity(
                        opacity:
                            _startTrainingController.isFinishState ? .2 : 1,
                        child: OutlinedButton(
                          onPressed: _startTrainingController.onTapAction,
                          child: Text(titleButton),
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
