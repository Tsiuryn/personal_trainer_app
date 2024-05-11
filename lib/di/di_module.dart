import 'package:get_it/get_it.dart';
import 'package:personal_trainer_app/data/gateway/body_lift_gateway_impl.dart';
import 'package:personal_trainer_app/data/gateway/pull_ups_gateway_impl.dart';
import 'package:personal_trainer_app/data/gateway/push_ups_gateway_impl.dart';
import 'package:personal_trainer_app/data/gateway/settings_gateway_impl.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

final getIt = GetIt.instance;

extension GetItExtension on GetIt {
  void setup() {
    getIt.registerSingleton<TrainingGateway>(
      PushUpsGatewayImpl(),
      instanceName: TrainingType.pushUps.value,
    );
    getIt.registerSingleton<TrainingGateway>(
      PullUpsGatewayImpl(),
      instanceName: TrainingType.pullUps.value,
    );
    getIt.registerSingleton<TrainingGateway>(
      BodyLiftGatewayImpl(),
      instanceName: TrainingType.bodyLifts.value,
    );
    getIt.registerSingleton<SettingsGateway>(SettingsGatewayImpl());
  }
}
