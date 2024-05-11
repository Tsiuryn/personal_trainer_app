import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_trainer_app/common/util/seconds_converter.dart';
import 'package:personal_trainer_app/domain/entity/trainer.dart';

mixin StartTrainingController<T extends StatefulWidget> on State<T> {
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration get restDuration;

  Training get training;

  void onSuccess();

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  bool get isLastIndex => _currentIndex == training.pushUpsCount.length - 1;

  Timer? _timer;

  DateTime _finishTime = DateTime.now();

  int get _sec => _finishTime.difference(DateTime.now()).inSeconds.abs();

  String? currentTime() {
    if (!isLastIndex && !isWorkNow) {
      return parseSeconds(_sec);
    }

    return null;
  }

  double getPercentTime() {
    if (isWorkNow) return 0;

    return _sec / restDuration.inSeconds;
  }

  TrainingState _currentState = TrainingState.work;
  get currentState => _currentState;
  bool get isWorkNow => _currentState == TrainingState.work;

  bool get isFinishState => isLastIndex && !isWorkNow;

  void onTapAction() {
    if (isFinishState) return;

    setState(() {
      _changeState();
      _nextIndex();
      _startStopTimer();
      _checkIsFinishState();
    });
  }

  void _changeState() {
    if (isLastIndex && !isWorkNow) return;

    _currentState = isWorkNow ? TrainingState.waiting : TrainingState.work;
  }

  void _nextIndex() {
    if (!isLastIndex && isWorkNow) {
      _currentIndex++;
    }
  }

  //Таймер запускается для отдыха
  void _startStopTimer() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }

    if (isLastIndex && !isWorkNow) return;

    if (!isWorkNow) {
      _finishTime = DateTime.now().add(restDuration);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_finishTime.isBefore(DateTime.now())) {
            _timer?.cancel();
            onTapAction();
          }
        });
      });
    }
  }

  void _checkIsFinishState() {
    if (isFinishState) {
      onSuccess();
    }
  }
}

enum TrainingState { waiting, work }
