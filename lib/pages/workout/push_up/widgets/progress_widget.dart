import 'package:flutter/material.dart';
import 'package:personal_trainer_app/domain/entity/push_up/push_up_trainer.dart';

class ProgressWidget extends StatelessWidget {
  final List<Training> training;
  const ProgressWidget({super.key, required this.training,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...training.map((e) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2,),
          child: SizedBox(
            height: 4,
            width: 8,
            child: ColoredBox(
              color: e.done ? Colors.lightGreen : Colors.grey,
            ),
          ),
        )).toList(),
      ],
    );
  }
}
