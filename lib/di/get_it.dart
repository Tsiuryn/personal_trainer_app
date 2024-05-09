import 'package:get_it/get_it.dart';
import 'package:personal_trainer_app/data/gateway/push_up_gateway_impl.dart';
import 'package:personal_trainer_app/data/gateway/settings_gateway_impl.dart';
import 'package:personal_trainer_app/domain/gateway/push_up_gateway.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';

final getIt = GetIt.instance;

extension GetItExtension on GetIt {
  void setup(){
    getIt.registerSingleton<PushUpGateway>(PushUpGatewayImpl());
    getIt.registerSingleton<SettingsGateway>(SettingsGatewayImpl());
  }
}