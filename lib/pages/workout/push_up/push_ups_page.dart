import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_colors.dart';
import 'package:personal_trainer_app/data/gateway/push_up_gateway_impl.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/domain/gateway/push_up_gateway.dart';

class PushUpsPage extends StatelessWidget {
  PushUpsPage({super.key}) {
    gateway = const PushUpGatewayImpl();
  }

  late final PushUpGateway gateway;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                itemCount: trainer.levels.length,
                itemBuilder: (context, index) {
                  final trainingLevel = trainer.levels[index];

                  return ListTile(
                    title: Text('Уровень ${trainingLevel.level}'),
                    subtitle: Text(
                        'От ${trainingLevel.minRange} до ${trainingLevel.maxRange}'),
                  );
                });
          }),
    );
  }
}
