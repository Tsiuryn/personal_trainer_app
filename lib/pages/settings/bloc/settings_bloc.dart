import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/entity/max_reps.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

class SettingsBloc extends Cubit<SettingsModel> {
  final SettingsGateway gateway;

  SettingsBloc({
    required this.gateway,
  }) : super(SettingsModel.empty()) {
    _initBloc();
  }

  void _initBloc() async {
    emit(state.copyWith(
      restDuration: await gateway.getRestTime(),
      maxReps: await _getReps(),
    ));
  }

  void setRestTime(Duration restTime) async {
    await gateway.setRestTime(restTime);
    emit(state.copyWith(restDuration: restTime));
  }

  void updateReps() async {
    emit(state.copyWith(maxReps: await _getReps()));
  }

  Future<Map<TrainingType, MaxReps>> _getReps() async {
    var values = <TrainingType, MaxReps>{};
    for (var element in TrainingType.values) {
      final maxReps = await gateway.getMaxReps(element);
      if (maxReps != null) {
        values[element] = maxReps;
      }
    }

    return values;
  }

  void clearHistory(TrainingType trainingType) async {
    final gateWay = trainingType.getTrainingGateway();

    await gateWay.clearHistory();
  }
}

class SettingsModel {
  final Duration restDuration;
  final Map<TrainingType, MaxReps> maxReps;

  const SettingsModel({
    required this.restDuration,
    required this.maxReps,
  });

  SettingsModel.empty()
      : restDuration = const Duration(seconds: 90),
        maxReps = {};

  SettingsModel copyWith({
    Duration? restDuration,
    Map<TrainingType, MaxReps>? maxReps,
  }) {
    return SettingsModel(
      restDuration: restDuration ?? this.restDuration,
      maxReps: maxReps ?? this.maxReps,
    );
  }
}
