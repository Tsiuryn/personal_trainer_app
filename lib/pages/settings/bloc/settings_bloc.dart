import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';

class SettingsBloc extends Cubit<SettingsModel> {
  final SettingsGateway gateway;

  SettingsBloc({
    required this.gateway,
  }) : super(SettingsModel.empty()) {
    _initBloc();
  }

  void _initBloc() async {
    emit(state.copyWith(restDuration: await gateway.getRestTime()));
  }

  void setRestTime(Duration restTime) async {
    await gateway.setRestTime(restTime);
    emit(state.copyWith(restDuration: restTime));
  }
}

class SettingsModel {
  final Duration restDuration;

  const SettingsModel({required this.restDuration});

  SettingsModel.empty() : restDuration = const Duration(seconds: 90);

  SettingsModel copyWith({
    Duration? restDuration,
  }) {
    return SettingsModel(
      restDuration: restDuration ?? this.restDuration,
    );
  }
}
