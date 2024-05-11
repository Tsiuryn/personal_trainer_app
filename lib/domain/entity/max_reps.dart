import 'package:json_annotation/json_annotation.dart';

part 'max_reps.g.dart';

@JsonSerializable()
class MaxReps {
  @JsonValue('value')
  final int value;
  @JsonValue('level')
  final int level;

  const MaxReps({
    required this.value,
    required this.level,
  });

  const MaxReps.empty()
      : value = -1,
        level = -1;

  factory MaxReps.fromJson(Map<String, dynamic> json) =>
      _$MaxRepsFromJson(json);

  Map<String, dynamic> toJson() => _$MaxRepsToJson(this);

  MaxReps copyWith({
    int? value,
    int? level,
  }) {
    return MaxReps(
      value: value ?? this.value,
      level: level ?? this.level,
    );
  }
}
