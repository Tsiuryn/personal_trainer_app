import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/domain/entity/push_up/trainer.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';

class PushUpDetailsBloc extends Cubit<PushUpDetailsModel> {
  final int indexTrainingLevel;
  final TrainingGateway gateway;
  final SettingsGateway settingsGateway;

  PushUpDetailsBloc({
    required this.indexTrainingLevel,
    required this.gateway,
    required this.settingsGateway,
  }) : super(PushUpDetailsModel.empty()) {
    _getPushUpTrainer();
    _listener();
  }

  void _getPushUpTrainer() async {
    final trainer = await gateway.getPushUpTrainer();
    final restTime = await settingsGateway.getRestTime();

    emit(state.copyWith(
      trainingLevel: trainer.levels[indexTrainingLevel],
      restTime: restTime,
    ));
  }

  void finishTraining(int indexTraining) async {
    final trainer = await gateway.getPushUpTrainer();

    // Directly update the relevant training entry, if it exists.
    if (indexTraining < trainer.levels[indexTrainingLevel].training.length) {
      // Update the done status of the specific training.
      final updatedTraining =
          trainer.levels[indexTrainingLevel].training[indexTraining].copyWith(
        successDate: DateTime.now(),
      );

      // Update the list in-place, as Dart lists are mutable.
      trainer.levels[indexTrainingLevel].training[indexTraining] =
          updatedTraining;

      // Update the trainer data in the gateway.
      await gateway.setPushUpTrainer(trainer);
    }
  }

  void _listener() {
    gateway.trainerStream().listen((trainer) {
      emit(state.copyWith(trainingLevel: trainer.levels[indexTrainingLevel]));
    });
  }
}

class PushUpDetailsModel {
  final TrainingLevel trainingLevel;
  final Duration restTime;

  PushUpDetailsModel({
    required this.trainingLevel,
    required this.restTime,
  });

  PushUpDetailsModel.empty()
      : trainingLevel = TrainingLevel.empty(),
        restTime = const Duration(seconds: 90);

  PushUpDetailsModel copyWith({
    TrainingLevel? trainingLevel,
    Duration? restTime,
  }) {
    return PushUpDetailsModel(
      trainingLevel: trainingLevel ?? this.trainingLevel,
      restTime: restTime ?? this.restTime,
    );
  }
}
