import 'package:personal_trainer_app/pages/training/util/training_type.dart';

abstract interface class SettingsGateway {
  Future<bool> setRestTime(Duration duration);
  Future<Duration> getRestTime();

  Future<bool> setMaxReps(TrainingType trainingType, int counts);
  Future<int> getMaxReps(TrainingType trainingType);
}