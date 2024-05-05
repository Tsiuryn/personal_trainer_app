import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_colors.dart';
import 'package:personal_trainer_app/common/util/extensions.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/workout/push_up/start_training_page.dart';

class PushUpDetailsPage extends StatelessWidget {
  final TrainingLevel trainingLevel;
  const PushUpDetailsPage({super.key, required this.trainingLevel, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Уровень ${trainingLevel.level}', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),),
            Text('От ${trainingLevel.minRange} до ${trainingLevel.maxRange}', style: TextStyle(
              fontSize: 12,
            ),),
          ],
        ),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child: ListView.builder(itemBuilder: (_, index){
              final Training training = trainingLevel.training[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Card(
                  child: ListTile(
                    onTap: (){
                      context.push(StartTrainingPage(training: training,));
                    },
                    title: Text(_getCountPushUps(training)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                           training.done ? Icons.workspace_premium_outlined : Icons.unpublished_outlined,
                          color: training.done ? Colors.yellow : Colors.grey,
                        ),
                        16.h,
                        const Icon(
                          Icons.label_important
                        )
                      ],
                    ),
                  ),
                ),
              );
            }, itemCount: trainingLevel.training.length,),
          )
        ],
      ),
    );
  }

  String _getCountPushUps(Training training){
    String value = '';

    for (var element in training.pushUpsCount.indexed) {
      bool isLast = element.$1 == training.pushUpsCount.length - 1;
      value += isLast ? '${element.$2}' : '${element.$2}, ';
    }

    return value;
  }
}
