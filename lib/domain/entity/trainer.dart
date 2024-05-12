import 'package:json_annotation/json_annotation.dart';

part 'trainer.g.dart';

@JsonSerializable()
class Trainer {
  @JsonValue('levels')
  final List<TrainingLevel> levels;

  const Trainer({
    required this.levels,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) =>
      _$TrainerFromJson(json);

  Map<String, dynamic> toJson() => _$TrainerToJson(this);

  Trainer.empty() : levels = [];

  Trainer copyWith({
    List<TrainingLevel>? levels,
  }) {
    return Trainer(
      levels: levels ?? this.levels,
    );
  }
}

@JsonSerializable()
class TrainingLevel {
  @JsonValue('level')
  final int level;
  @JsonValue('minRange')
  final int minRange;
  @JsonValue('maxRange')
  final int maxRange;
  @JsonValue('training')
  final List<Training> training;

  const TrainingLevel({
    required this.level,
    required this.minRange,
    required this.maxRange,
    required this.training,
  });

  factory TrainingLevel.fromJson(Map<String, dynamic> json) =>
      _$TrainingLevelFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingLevelToJson(this);

  TrainingLevel.empty()
      : level = -1,
        minRange = -1,
        maxRange = -1,
        training = [];

  TrainingLevel copyWith({
    int? level,
    int? minRange,
    int? maxRange,
    List<Training>? training,
  }) {
    return TrainingLevel(
      level: level ?? this.level,
      minRange: minRange ?? this.minRange,
      maxRange: maxRange ?? this.maxRange,
      training: training ?? this.training,
    );
  }
}

@JsonSerializable()
class Training {
  @JsonValue('pushUpsCount')
  final List<int> pushUpsCount;
  @JsonValue('statisticTraining')
  final StatisticTraining? statisticTraining;

  const Training({
    required this.pushUpsCount,
    this.statisticTraining,
  });

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingToJson(this);

  Training.empty()
      : pushUpsCount = [],
        statisticTraining = null;

  Training copyWith({
    List<int>? pushUpsCount,
    StatisticTraining? statisticTraining,
  }) {
    return Training(
      pushUpsCount: pushUpsCount ?? this.pushUpsCount,
      statisticTraining: statisticTraining ?? this.statisticTraining,
    );
  }
}

@JsonSerializable()
class StatisticTraining {
  @JsonValue('startDate')
  final DateTime startDate;
  @JsonValue('finishDate')
  final DateTime finishDate;

  const StatisticTraining({
    required this.startDate,
    required this.finishDate,
  });

  factory StatisticTraining.fromJson(Map<String, dynamic> json) =>
      _$StatisticTrainingFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticTrainingToJson(this);

  StatisticTraining copyWith({
    DateTime? startDate,
    DateTime? finishDate,
  }) {
    return StatisticTraining(
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
    );
  }
}
