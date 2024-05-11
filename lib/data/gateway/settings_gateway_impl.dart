import 'dart:convert';

import 'package:personal_trainer_app/domain/entity/max_reps.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _restTimeKey = 'restTimeKey';

class SettingsGatewayImpl implements SettingsGateway {
  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  SettingsGatewayImpl();

  @override
  Future<Duration> getRestTime() async {
    final seconds = (await prefs).getInt(_restTimeKey) ?? 90;

    return Duration(seconds: seconds);
  }

  @override
  Future<bool> setRestTime(Duration duration) async {
    final seconds = duration.inSeconds;

    return await (await prefs).setInt(_restTimeKey, seconds);
  }

  @override
  Future<MaxReps?> getMaxReps(TrainingType trainingType) async{
    final sourceValue = (await prefs).getString(_getMaxRepsKey(trainingType));

    if(sourceValue != null){
      return MaxReps.fromJson(jsonDecode(sourceValue));
    }

    return null;
  }

  @override
  Future<bool> setMaxReps(TrainingType trainingType, MaxReps maxReps) async {
    return (await prefs).setString(_getMaxRepsKey(trainingType), jsonEncode(maxReps.toJson()));
  }
  
  String _getMaxRepsKey (TrainingType trainingType) => '${trainingType.value}_reps';
}
