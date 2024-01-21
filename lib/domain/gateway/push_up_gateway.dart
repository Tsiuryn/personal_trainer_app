import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';

abstract interface class PushUpGateway {
  Future<PushUpTrainer> getPushUpTrainer();
}
