import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/check_level/bloc/check_level_bloc.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

class CheckLevelPage extends StatelessWidget {
  final TrainingType trainingType;

  const CheckLevelPage({
    super.key,
    required this.trainingType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckLevelBloc>(
      create: (_) => CheckLevelBloc(
        trainingType: trainingType,
        settingsGateway: getIt.get<SettingsGateway>(),
      ),
      child: BlocConsumer<CheckLevelBloc, CheckLevelModel>(
        listener: (context, state) {
          if (state.state == CheckLevelModelLoading.finish) {
            context.pop(true);
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  title: Text(
                    'Определение уровня',
                    style: AppTheme.appBarTitle,
                  ),
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: context.pop,
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppTheme.white,
                    ),
                  ),
                  automaticallyImplyLeading: false,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        trainingType.checkLevelDescription,
                        style: AppTheme.subTitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    _BlockCount(
                      initialValue:
                          state.maxReps == null ? 0 : state.maxReps!.value,
                      onTap: context.read<CheckLevelBloc>().updateMaxReps,
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        context.read<CheckLevelBloc>().setMaxReps();
                      },
                      child: Text(
                        'Продолжить',
                        style: AppTheme.trainingButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: state.state == CheckLevelModelLoading.loading,
                child: const CircularProgressIndicator(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BlockCount extends StatelessWidget {
  final int initialValue;
  final Function(int) onTap;

  const _BlockCount({required this.initialValue, required this.onTap});

  Widget getIconButton(
    String title,
    VoidCallback onTap, {
    required String heroTag,
  }) =>
      FloatingActionButton(
        onPressed: onTap,
        mini: true,
        heroTag: heroTag,
        child: Text(title),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getIconButton('+5', () {
          onTap(initialValue + 5);
        }, heroTag: '1'),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getIconButton('-1', () {
                onTap(initialValue - 1);
              }, heroTag: '2'),
              Text(
                initialValue.toString(),
                style: AppTheme.trainingTimer,
              ),
              getIconButton('+1', () {
                onTap(initialValue + 1);
              }, heroTag: '3'),
            ],
          ),
        ),
        getIconButton('-5', () {
          onTap(initialValue - 5);
        }, heroTag: '4'),
      ],
    );
  }
}
