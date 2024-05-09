import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/domain/gateway/push_up_gateway.dart';

class PushUpDetailsBloc extends Cubit<PushUpDetailsModel> {
  final int indexTrainingLevel;
  final PushUpGateway gateway;

  PushUpDetailsBloc({
    required this.indexTrainingLevel,
    required this.gateway,
  }) : super(PushUpDetailsModel.empty()){
    _getPushUpTrainer();
    _listener();
  }

  void _getPushUpTrainer() async{
    final trainer  = await gateway.getPushUpTrainer();

    emit(state.copyWith(trainingLevel: trainer.levels[indexTrainingLevel]));

  }

  void finishTraining(int indexTraining) async {
    final trainer  = await gateway.getPushUpTrainer();

    // Directly update the relevant training entry, if it exists.
    if (indexTraining < trainer.levels[indexTrainingLevel].training.length) {
      // Update the done status of the specific training.
      final updatedTraining = trainer.levels[indexTrainingLevel].training[indexTraining]
          .copyWith(done: true);

      // Update the list in-place, as Dart lists are mutable.
      trainer.levels[indexTrainingLevel].training[indexTraining] = updatedTraining;

      // Update the trainer data in the gateway.
      await gateway.setPushUpTrainer(trainer);
    }
  }

  void _listener(){
    gateway.trainerStream().listen((trainer) {
      emit(state.copyWith(trainingLevel: trainer.levels[indexTrainingLevel]));
    });
  }
}

class PushUpDetailsModel {
  final TrainingLevel trainingLevel;

  PushUpDetailsModel({
    required this.trainingLevel,
  });

  PushUpDetailsModel.empty(): trainingLevel = TrainingLevel.empty();

  PushUpDetailsModel copyWith({
    TrainingLevel? trainingLevel,
  }) {
    return PushUpDetailsModel(
      trainingLevel: trainingLevel ?? this.trainingLevel,
    );
  }
}
