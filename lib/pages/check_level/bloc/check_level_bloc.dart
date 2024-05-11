import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/entity/max_reps.dart';
import 'package:personal_trainer_app/domain/entity/trainer.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

class CheckLevelBloc extends Cubit<CheckLevelModel> {
  final TrainingType trainingType;
  final SettingsGateway settingsGateway;

  CheckLevelBloc({
    required this.trainingType,
    required this.settingsGateway,
  }) : super(CheckLevelModel.empty()) {
    _getSettingsReps();
  }

  void _getSettingsReps() async {
    emit(state.copyWith(state: CheckLevelModelLoading.loading));
    emit(state.copyWith(
        maxReps: await settingsGateway.getMaxReps(trainingType), state: CheckLevelModelLoading.success,));
  }

  void setMaxReps() async {
    if(state.maxReps != null) {
      emit(state.copyWith(state: CheckLevelModelLoading.loading));
      await settingsGateway.setMaxReps(trainingType, state.maxReps!.copyWith(
        level: await _getCurrentLevel(state.maxReps!.value),
      ));
    }
      emit(state.copyWith(state: CheckLevelModelLoading.finish));
  }

  Future<int> _getCurrentLevel (int maxReps) async {
    final gateway = getIt.get<TrainingGateway>(instanceName: trainingType.value);

    final trainer = await gateway.getTrainer();
    var currentLevel = 0;
    for ((int, TrainingLevel) element in trainer.levels.indexed) {
      final level = element.$2;
      if(level.minRange <= maxReps && maxReps <= level.maxRange){
        currentLevel = element.$1 + 1;
      }
      if(element.$1 == trainer.levels.length - 1 && maxReps > level.maxRange){
        currentLevel = element.$1 + 2;
      }
    }

    return currentLevel;
  }

  void updateMaxReps(int reps) {
    var currentReps = reps;
    if (currentReps < 0) currentReps = 0;

    final maxReps = state.maxReps ?? const MaxReps.empty();

    emit(state.copyWith(maxReps: maxReps.copyWith(value: currentReps)));
  }
}

class CheckLevelModel {
  final MaxReps? maxReps;
  final CheckLevelModelLoading state;

  CheckLevelModel({
    required this.maxReps,
    required this.state,
  });
  CheckLevelModel.empty() : maxReps = null, state = CheckLevelModelLoading.loading ;

  CheckLevelModel copyWith({
    MaxReps? maxReps,
    CheckLevelModelLoading? state,
  }) {
    return CheckLevelModel(
      maxReps: maxReps ?? this.maxReps,
      state: state ?? this.state,
    );
  }
}

enum CheckLevelModelLoading{
  loading, success, finish
}
