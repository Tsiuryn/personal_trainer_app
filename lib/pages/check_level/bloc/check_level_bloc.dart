import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

class CheckLevelBloc extends Cubit<CheckLevelModel> {
  final TrainingType trainingType;
  final SettingsGateway settingsGateway;

  CheckLevelBloc({required this.trainingType, required this.settingsGateway,}):super(CheckLevelModel.empty()){
    _getSettingsReps();
  }

  void _getSettingsReps() async{
    emit(state.copyWith(maxReps: await settingsGateway.getMaxReps(trainingType)));
  }

  void setMaxReps() async{
    await settingsGateway.setMaxReps(trainingType, state.maxReps);
  }

  void updateMaxReps(int reps) {
    var currentReps = reps;
    if(currentReps < 0) currentReps = 0;

    emit(state.copyWith(maxReps: currentReps));
  }
}

class CheckLevelModel{
  final int maxReps;

  CheckLevelModel({required this.maxReps,});
  CheckLevelModel.empty() : maxReps = 0;

  CheckLevelModel copyWith({
    int? maxReps,
  }) {
    return CheckLevelModel(
      maxReps: maxReps ?? this.maxReps,
    );
  }
}