import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/generated/resources.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/training/training_page.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  _WorkoutItem(
                      imagePath: AppRes.pushUp,
                      title: 'Отжимания',
                      onTap: () {
                        context.push(TrainingPage(
                          trainingType: TrainingType.pushUps,
                        ));
                      }),
                  _WorkoutItem(
                    imagePath: AppRes.abTrain,
                    title: 'Пресс',
                    onTap: () {
                      context.push(TrainingPage(
                        trainingType: TrainingType.bodyLifts,
                      ));
                    },
                  ),
                  _WorkoutItem(
                      imagePath: AppRes.pullUp,
                      title: 'Подтягивания',
                      onTap: () {
                        context.push(TrainingPage(
                          trainingType: TrainingType.pullUps,
                        ));
                      }),
                  _WorkoutItem(
                      imagePath: AppRes.squats,
                      title: 'Приседания',
                      onTap: () {
                        context.push(TrainingPage(
                          trainingType: TrainingType.squats,
                        ));
                      }),
                  const SizedBox(
                    height: 32,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _WorkoutItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const _WorkoutItem({
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 32,
      ),
      decoration: BoxDecoration(
          color: AppTheme.white, borderRadius: BorderRadius.circular(16)),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.fitWidth,
                    )),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: AppTheme.black,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
