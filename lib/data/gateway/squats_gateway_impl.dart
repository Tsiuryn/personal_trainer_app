import 'dart:convert';
import 'dart:developer';

import 'package:personal_trainer_app/common/util/training_calculator.dart';
import 'package:personal_trainer_app/domain/entity/trainer.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefKey = 'squatsTrainer';

class SquatsGatewayImpl implements TrainingGateway {
  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  SquatsGatewayImpl();

  final PublishSubject<Trainer> _subject = PublishSubject();

  @override
  Future<Trainer> getTrainer() async {
    const tc = TrainingCalculator(trainingInLevels: 4, numberOfLevels: 25,);
    try {
      final pf = await prefs;

      final source = pf.getString(_prefKey);

      if (source != null) {
        final json = jsonDecode(source);

        return Trainer.fromJson(json);
      }

      return tc.workoutList();
    } catch (e) {
      log(e.toString());
      return tc.workoutList();
    }
  }

  @override
  Future<void> setTrainer(Trainer pushUpTrainer) async {
    _subject.add(pushUpTrainer);
    final json = pushUpTrainer.toJson();
    final pf = await prefs;

    await pf.setString(_prefKey, jsonEncode(json));
  }

  @override
  Stream<Trainer> trainerStream() {
    return _subject.stream;
  }

  @override
  Future<bool> clearHistory() async {
    return (await prefs).remove(_prefKey);
  }
}
