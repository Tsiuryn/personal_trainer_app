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
    final newTrainer = state.trainingLevel.training[indexTraining].copyWith(done: true);
    final training = [...state.trainingLevel.training];
    training[indexTraining] = newTrainer;

    final levels = [...trainer.levels];
    final currentLevel = levels[indexTrainingLevel];
    final update = currentLevel.copyWith(training: training);
    levels[indexTrainingLevel] = update;

    final updatedTrainer = trainer.copyWith(levels: levels);

    gateway.setPushUpTrainer(updatedTrainer);

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
