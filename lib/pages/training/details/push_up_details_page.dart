import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/common/base/loading_page.dart';
import 'package:personal_trainer_app/common/util/extensions.dart';
import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/entity/trainer.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/training/details/bloc/push_up_details_bloc.dart';
import 'package:personal_trainer_app/pages/training/training/start_training_page.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

class TrainingDetailsPage extends StatelessWidget {
  final int indexTrainingLevel;
  final TrainingType trainingType;

  const TrainingDetailsPage({
    super.key,
    required this.indexTrainingLevel,
    required this.trainingType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PushUpDetailsBloc>(
      create: (_) => PushUpDetailsBloc(
        indexTrainingLevel: indexTrainingLevel,
        gateway: getIt.get<TrainingGateway>(
          instanceName: trainingType.value,
        ),
        settingsGateway: getIt.get<SettingsGateway>(),
      ),
      child: BlocBuilder<PushUpDetailsBloc, PushUpDetailsModel>(
          builder: (context, state) {
        final trainingLevel = state.trainingLevel;
        if (trainingLevel.level == -1) {
          return const LoadingPage();
        }

        return Scaffold(
          backgroundColor: AppTheme.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: context.pop,
              icon: Icon(
                Icons.arrow_back,
                color: AppTheme.white,
              ),
            ),
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Уровень ${trainingLevel.level}',
                  style: AppTheme.appBarTitle,
                ),
                Text(
                  'От ${trainingLevel.minRange} до ${trainingLevel.maxRange}',
                  style: AppTheme.description,
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    final Training training = trainingLevel.training[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            context
                                .push(StartTrainingPage(
                              training: training,
                              restTime: state.restTime,
                            ))
                                .then((value) {
                              if (value != null && value == true) {
                                context
                                    .read<PushUpDetailsBloc>()
                                    .finishTraining(index);
                              }
                            });
                          },
                          title: Text(_getCountPushUps(training)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    training.successDate != null
                                        ? Icons.workspace_premium_outlined
                                        : Icons.unpublished_outlined,
                                    color: training.successDate != null
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  if (training.successDate != null)
                                    Text(
                                      '${DateFormat.yMEd('ru').format(training.successDate!)} ${DateFormat.Hm().format(training.successDate!)}',
                                      style: AppTheme.description.copyWith(
                                        color: AppTheme.black,
                                      ),
                                    )
                                ],
                              ),
                              16.h,
                              const Icon(Icons.label_important)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: trainingLevel.training.length,
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  String _getCountPushUps(Training training) {
    String value = '';

    for (var element in training.pushUpsCount.indexed) {
      bool isLast = element.$1 == training.pushUpsCount.length - 1;
      value += isLast ? '${element.$2}' : '${element.$2}, ';
    }

    final count = training.pushUpsCount.reduce((a, b) => a + b);

    return '$value ($count)';
  }
}
