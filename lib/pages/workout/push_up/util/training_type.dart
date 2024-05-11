import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';

enum TrainingType {
  pushUps ('pushUps'),
  pullUps ('pullUps'),
  bodyLifts ('bodyLifts');

  final String value;

  const TrainingType(this.value);
}

extension TrainingTypeExtension on TrainingType {
  TrainingGateway getTrainingGateway() {
    return switch (this) {
      TrainingType.pushUps => getIt.get<TrainingGateway>(),
      TrainingType.pullUps => getIt.get<TrainingGateway>(),
      TrainingType.bodyLifts => getIt.get<TrainingGateway>(),
    };
  }

  String get trainingPageTitle => switch (this) {
  TrainingType.pushUps => 'Программа отжиманий',
  TrainingType.pullUps => 'Программа подтягиваний',
  TrainingType.bodyLifts => 'Тренировка пресса',
  };
}
