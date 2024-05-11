import 'package:personal_trainer_app/domain/entity/push_up/trainer.dart';

abstract interface class TrainingGateway {

  Stream<Trainer> trainerStream();
  Future<Trainer> getPushUpTrainer();
  Future<void> setPushUpTrainer(Trainer pushUpTrainer);
  Future<bool> clearStatistics();
}
