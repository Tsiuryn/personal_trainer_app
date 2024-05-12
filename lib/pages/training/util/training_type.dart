import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';

enum TrainingType {
  pushUps('pushUps'),
  pullUps('pullUps'),
  bodyLifts('bodyLifts'),
  squats('squats');

  final String value;

  const TrainingType(this.value);
}

extension TrainingTypeExtension on TrainingType {
  TrainingGateway getTrainingGateway() {
    return switch (this) {
      TrainingType.pushUps => getIt.get<TrainingGateway>(instanceName: value),
      TrainingType.pullUps => getIt.get<TrainingGateway>(instanceName: value),
      TrainingType.bodyLifts => getIt.get<TrainingGateway>(instanceName: value),
      TrainingType.squats => getIt.get<TrainingGateway>(instanceName: value),
    };
  }

  String get trainingPageTitle => switch (this) {
        TrainingType.pushUps => 'Программа отжиманий',
        TrainingType.pullUps => 'Программа подтягиваний',
        TrainingType.bodyLifts => 'Тренировка пресса',
        TrainingType.squats => 'Программа приседаний',
      };

  String get settingsPageStatisticsTitle => switch (this) {
        TrainingType.pushUps => 'Максимальное количество отжиманий',
        TrainingType.pullUps => 'Максимальное количество подтягиваний',
        TrainingType.bodyLifts => 'Максимальное количество подъемов туловища',
        TrainingType.squats => 'Максимальное количество приседаний',
      };

  String get settingsPageClearDataTitle => switch (this) {
        TrainingType.pushUps => 'Очистить историю отжиманий',
        TrainingType.pullUps => 'Очистить историю подтягиваний',
        TrainingType.bodyLifts => 'Очистить историю подъемов туловища',
        TrainingType.squats => 'Очистить историю приседаний',
      };

  String get checkLevelDescription => switch (this) {
        TrainingType.pushUps =>
          'Выполните максимальное количество отжиманий и нажмите кнопку "Продолжить"',
        TrainingType.pullUps =>
          'Выполните максимальное количество подтягиваний и нажмите кнопку "Продолжить"',
        TrainingType.bodyLifts =>
          'Выполните максимальное количество подъемов туловища и нажмите кнопку "Продолжить"',
        TrainingType.squats =>
          'Выполните максимальное количество приседаний и нажмите кнопку "Продолжить"',
      };
}
