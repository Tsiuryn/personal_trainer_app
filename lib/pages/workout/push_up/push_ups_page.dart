import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/app/app_colors.dart';
import 'package:personal_trainer_app/common/util/extensions.dart';
import 'package:personal_trainer_app/data/gateway/push_up_gateway_impl.dart';
import 'package:personal_trainer_app/di/get_it.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';
import 'package:personal_trainer_app/domain/gateway/push_up_gateway.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/workout/push_up/bloc/push_ups_bloc.dart';
import 'package:personal_trainer_app/pages/workout/push_up/details/push_up_details_page.dart';
import 'package:personal_trainer_app/pages/workout/push_up/widgets/progress_widget.dart';

class PushUpsPage extends StatelessWidget {
  PushUpsPage({super.key}) {
    gateway = PushUpGatewayImpl();
  }

  late final PushUpGateway gateway;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConst.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back,
            color: AppConst.white,
          ),
        ),
      ),
      body: BlocProvider<PushUpsBloc>(
        create: (_)
            => PushUpsBloc(gateway: getIt.get<PushUpGateway>()),
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
                            context.push(PushUpDetailsPage(indexTrainingLevel: index,));
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
