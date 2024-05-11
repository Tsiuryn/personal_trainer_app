import 'package:personal_trainer_app/domain/entity/trainer.dart';

abstract interface class TrainingGateway {
  Stream<Trainer> trainerStream();
  Future<Trainer> getTrainer();
  Future<void> setTrainer(Trainer pushUpTrainer);
  Future<bool> clearHistory();
}
