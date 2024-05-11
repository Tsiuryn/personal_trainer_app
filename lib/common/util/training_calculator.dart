import 'package:personal_trainer_app/domain/entity/push_up/trainer.dart';

class TrainingCalculator {

  /// Начальное количество повторений
  final int initialReps;

  /// прогресс в повторениях для одного уровня
  final int repsIncrement;

  /// количество уровней
  final int numberOfLevels;

  /// количество тренировок в одном уровне
  final int trainingInLevels;

  /// коэффициент сложности уровня
  final double difficultyFactor;


  const TrainingCalculator({
    this.initialReps = 6,
    this.repsIncrement = 5,
    this.numberOfLevels = 29,
    this.trainingInLevels = 5,
    this.difficultyFactor = .8
  });


  Trainer workoutList() {


    List<TrainingLevel> levels = [];

    int checkNumber(int count){
      if(count < 1) return 1;

      return count;
    }

    for (int level = 1; level <= numberOfLevels; level++) {
      int minReps = initialReps + (level - 1) * repsIncrement;
      int maxReps = minReps + 4;

      // log("Уровень $level: Отжимания от $minReps до $maxReps");

      List<Training> training = [];

      int min = minReps;
      for (int workout = 1; workout <= trainingInLevels; workout++) {
        int firstSetReps = checkNumber(((min * difficultyFactor) - 1.0).toInt());
        int secondSetReps = checkNumber(firstSetReps + 2);
        int thirdSetReps = checkNumber(firstSetReps - 1);
        int fourthSetReps = checkNumber(firstSetReps - 1);
        int fifthSetReps = checkNumber(firstSetReps + 3);

        // log("\nТренировка $workout: $firstSetReps-$secondSetReps-$thirdSetReps-$fourthSetReps-$fifthSetReps");

        List<int> pushUpsCount = [];

        pushUpsCount
          ..add(firstSetReps)
          ..add(secondSetReps)
          ..add(thirdSetReps)
          ..add(fourthSetReps)
          ..add(fifthSetReps);

        training.add(
          Training(
            pushUpsCount: pushUpsCount,
          ),
        );

        min++;
      }

      levels.add(TrainingLevel(
        level: level,
        minRange: minReps,
        maxRange: maxReps,
        training: training,
      ));
    }

    return Trainer(levels: levels);
  }

}