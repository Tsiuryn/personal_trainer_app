import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/domain/gateway/push_up_gateway.dart';

class PushUpsBloc extends Cubit <PushUpsModel>{
  final PushUpGateway gateway;

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
  final PushUpTrainer trainer;

  PushUpsModel({required this.trainer});

  PushUpsModel.empty(): trainer = PushUpTrainer.empty();

  PushUpsModel copyWith({
    PushUpTrainer? trainer,
  }) {
    return PushUpsModel(
      trainer: trainer ?? this.trainer,
    );
  }
}