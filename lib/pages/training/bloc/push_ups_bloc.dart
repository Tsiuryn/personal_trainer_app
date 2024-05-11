import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/domain/entity/push_up/trainer.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';

class PushUpsBloc extends Cubit <PushUpsModel>{
  final TrainingGateway gateway;

  PushUpsBloc({required this.gateway,})
      : super(PushUpsModel.empty()){
    _listener();
    getPushUpTrainer();
  }

  void getPushUpTrainer() async{
    final trainer = await gateway.getPushUpTrainer();
    emit(state.copyWith(trainer: trainer));
  }

  void _listener(){
    gateway.trainerStream().listen((event) {
      emit(state.copyWith(trainer: event));
    });
  }
}

class PushUpsModel {
  final Trainer trainer;

  PushUpsModel({required this.trainer});

  PushUpsModel.empty(): trainer = Trainer.empty();

  PushUpsModel copyWith({
    Trainer? trainer,
  }) {
    return PushUpsModel(
      trainer: trainer ?? this.trainer,
    );
  }
}