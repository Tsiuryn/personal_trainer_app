import 'package:json_annotation/json_annotation.dart';

part 'push_up_trainer.g.dart';

@JsonSerializable()
class PushUpTrainer {
  @JsonValue('levels')
  final List<TrainingLevel> levels;

  const PushUpTrainer({
    required this.levels,
  });

  factory PushUpTrainer.fromJson(Map<String, dynamic> json) =>
      _$PushUpTrainerFromJson(json);

  Map<String, dynamic> toJson() => _$PushUpTrainerToJson(this);

  PushUpTrainer.empty(): levels = [];

  PushUpTrainer copyWith({
    List<TrainingLevel>? levels,
  }) {
    return PushUpTrainer(
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

  TrainingLevel.empty(): level = -1, minRange = -1, maxRange = -1, training = [];

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
  @JsonValue('done')
  final bool done;

  const Training({
    required this.pushUpsCount,
    required this.done,
  });

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingToJson(this);

  Training.empty(): pushUpsCount = [], done = false;

  Training copyWith({
    List<int>? pushUpsCount,
    bool? done,
  }) {
    return Training(
      pushUpsCount: pushUpsCount ?? this.pushUpsCount,
      done: done ?? this.done,
    );
  }
}
