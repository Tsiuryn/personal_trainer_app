import 'dart:convert';
import 'dart:developer';

import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/domain/gateway/push_up_gateway.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _pushUpTrainer = 'pushUpTrainer';

class PushUpGatewayImpl implements PushUpGateway {
  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  PushUpGatewayImpl();

  final PublishSubject<PushUpTrainer> _subject = PublishSubject();

  @override
  Future<PushUpTrainer> getPushUpTrainer() async {
    try {
      final pf = await prefs;

      final source = pf.getString(_pushUpTrainer);

      if (source != null) {
        final json = jsonDecode(source);

        return PushUpTrainer.fromJson(json);
      }

      return _PushUpsCalculator.workoutList();
    } catch (e) {
      log(e.toString());
      return _PushUpsCalculator.workoutList();
    }
  }

  double getCoefficient(int level) {
    switch (level) {
      case < 21:
        return 0.75;
      default:
        return 1;
    }
  }

  @override
  Future<void> setPushUpTrainer(PushUpTrainer pushUpTrainer) async{
    _subject.add(pushUpTrainer);
    final json = pushUpTrainer.toJson();
    final pf = await prefs;

    await pf.setString(_pushUpTrainer, jsonEncode(json));
  }

  @override
  Stream<PushUpTrainer> trainerStream() {
    return _subject.stream;
  }
}

class _PushUpsCalculator {
  static PushUpTrainer workoutList() {
    int initialReps = 6;
    int repsIncrement = 5;
    int numberOfLevels = 29;

    List<TrainingLevel> levels = [];

    for (int level = 1; level <= numberOfLevels; level++) {
      int minReps = initialReps + (level - 1) * repsIncrement;
      int maxReps = minReps + 4;

      // log("Уровень $level: Отжимания от $minReps до $maxReps");

      List<Training> training = [];

      int min = minReps;
      for (int workout = 1; workout <= 4; workout++) {
        int firstSetReps = (min * (_getCoefficient(level)) - 1).toInt();
        int secondSetReps = firstSetReps + 2;
        int thirdSetReps = firstSetReps - 1;
        int fourthSetReps = firstSetReps - 1;
        int fifthSetReps = firstSetReps + 3;

        // log("\nТренировка $workout: $firstSetReps-$secondSetReps-$thirdSetReps-$fourthSetReps-$fifthSetReps");

        List<int> pushUpsCount = [];

        pushUpsCount
          ..add(firstSetReps)
          ..add(secondSetReps)
          ..add(thirdSetReps)
          ..add(fourthSetReps)
          ..add(fifthSetReps);

        training.add(Training(
          pushUpsCount: pushUpsCount,
          done: false,
        ));

        min++;
      }

      levels.add(TrainingLevel(
        level: level,
        minRange: minReps,
        maxRange: maxReps,
        training: training,
      ));
    }

    return PushUpTrainer(levels: levels);
  }

  static double _getCoefficient(int level) {
    switch (level) {
      case < 21:
        return 0.75;
      case < 41:
        return 0.7;
      case < 61:
        return 0.65;
      case < 81:
        return 0.6;
      case < 101:
        return 0.55;
      case < 121:
        return 0.5;
      case < 141:
        return 0.45;
      case < 161:
        return 0.4;
      default:
        return 1;
    }
  }
}
