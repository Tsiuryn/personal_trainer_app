import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';

abstract interface class PushUpGateway {

  Stream<PushUpTrainer> trainerStream();
  Future<PushUpTrainer> getPushUpTrainer();
  Future<void> setPushUpTrainer(PushUpTrainer pushUpTrainer);
}
