import 'package:flutter/material.dart';
import 'package:personal_trainer_app/common/util/extensions.dart';
import 'package:personal_trainer_app/data/gateway/push_up_gateway_impl.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/domain/gateway/push_up_gateway.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/workout/push_up/push_up_details_page.dart';
import 'package:personal_trainer_app/pages/workout/push_up/widgets/progress_widget.dart';

class PushUpsPage extends StatelessWidget {
  PushUpsPage({super.key}) {
    gateway = const PushUpGatewayImpl();
  }

  late final PushUpGateway gateway;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: FutureBuilder<PushUpTrainer>(
          future: gateway.getPushUpTrainer(),
          builder: (context, snapshot) {
            final trainer = snapshot.data;
            if (trainer == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
                itemCount: trainer.levels.length,
                itemBuilder: (context, index) {
                  final TrainingLevel trainingLevel = trainer.levels[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4,),
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      child: ListTile(
                        onTap: (){
                          context.push(PushUpDetailsPage(trainingLevel: trainingLevel,));
                        },
                        title: Text('Уровень ${trainingLevel.level}'),
                        subtitle: Text(
                            'От ${trainingLevel.minRange} до ${trainingLevel.maxRange}',),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ProgressWidget(
                              training: trainingLevel.training,
                            ),
                            16.h,
                            Icon(
                              Icons.label_important,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
