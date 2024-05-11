import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/common/util/extensions.dart';
import 'package:personal_trainer_app/data/gateway/push_ups_gateway_impl.dart';
import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/entity/push_up/trainer.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/workout/push_up/bloc/push_ups_bloc.dart';
import 'package:personal_trainer_app/pages/workout/push_up/details/push_up_details_page.dart';
import 'package:personal_trainer_app/pages/workout/push_up/util/training_type.dart';
import 'package:personal_trainer_app/pages/workout/push_up/widgets/progress_widget.dart';

class TrainingPage extends StatelessWidget {
  final TrainingType trainingType;
  const TrainingPage({super.key, required this.trainingType,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(trainingType.trainingPageTitle, style: AppTheme.appBarTitle,),
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.white,
          ),
        ),
      ),
      body: BlocProvider<PushUpsBloc>(
        create: (_)
            => PushUpsBloc(gateway: getIt.get<TrainingGateway>(instanceName: trainingType.value)),
        child: BlocBuilder<PushUpsBloc, PushUpsModel>(
            builder: (context, state) {
              final trainer = state.trainer;
              if (trainer.levels.isEmpty) {
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
                            context.push(TrainingDetailsPage(indexTrainingLevel: index, trainingType: trainingType,));
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
                              const Icon(
                                Icons.label_important,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
