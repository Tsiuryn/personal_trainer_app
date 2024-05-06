import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/common/base/loading_page.dart';
import 'package:personal_trainer_app/common/util/extensions.dart';
import 'package:personal_trainer_app/di/get_it.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/workout/push_up/details/bloc/push_up_details_bloc.dart';
import 'package:personal_trainer_app/pages/workout/push_up/training/start_training_page.dart';

class PushUpDetailsPage extends StatelessWidget {
  final int indexTrainingLevel;

  const PushUpDetailsPage({
    super.key,
    required this.indexTrainingLevel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PushUpDetailsBloc>(
      create: (_) => PushUpDetailsBloc(
        indexTrainingLevel: indexTrainingLevel,
        gateway: getIt.get(),
      ),
      child: BlocBuilder<PushUpDetailsBloc, PushUpDetailsModel>(
        builder: (context, state) {
          final trainingLevel = state.trainingLevel;
          if(trainingLevel.level == -1){
            return const LoadingPage();
          }

          return Scaffold(
            appBar: AppBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Уровень ${trainingLevel.level}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'От ${trainingLevel.minRange} до ${trainingLevel.maxRange}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
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
                              ))
                                  .then((value) {
                                if (value != null && value == true) {
                                  context.read<PushUpDetailsBloc>().finishTraining(index);
                                }
                              });
                            },
                            title: Text(_getCountPushUps(training)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  training.done
                                      ? Icons.workspace_premium_outlined
                                      : Icons.unpublished_outlined,
                                  color:
                                      training.done ? Colors.green : Colors.grey,
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
        }
      ),
    );
  }

  String _getCountPushUps(Training training) {
    String value = '';

    for (var element in training.pushUpsCount.indexed) {
      bool isLast = element.$1 == training.pushUpsCount.length - 1;
      value += isLast ? '${element.$2}' : '${element.$2}, ';
    }

    return value;
  }
}
