import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _restTimeKey = 'restTimeKey';

class SettingsGatewayImpl implements SettingsGateway {

  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  SettingsGatewayImpl();

  @override
  Future<Duration> getRestTime() async{
    final seconds = (await prefs).getInt(_restTimeKey) ?? 90;

    return Duration(seconds: seconds);
  }

  @override
  Future<bool> setRestTime(Duration duration) async{
    final seconds = duration.inSeconds;

    return await (await prefs).setInt(_restTimeKey, seconds);
  }

  @override
  Future<int> getMaxReps(TrainingType trainingType) async {
    return (await prefs).getInt('${trainingType.value}_reps') ?? 0;
  }

  @override
  Future<bool> setMaxReps(TrainingType trainingType, int counts) async {
    return (await prefs).setInt('${trainingType.value}_reps', counts);
  }
}