import 'package:flutter/material.dart';
import 'package:personal_trainer_app/domain/entity/trainer.dart';

class ProgressWidget extends StatelessWidget {
  final List<Training> training;
  const ProgressWidget({
    super.key,
    required this.training,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...training.map((e) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              child: Container(
                height: 16,
                width: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color:
                      e.statisticTraining != null ? Colors.green : Colors.grey,
                ),
              ),
            )),
      ],
    );
  }
}
