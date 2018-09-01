import 'dart:ui';

import 'package:app/models/produce.dart';
import 'package:meta/meta.dart';

import 'farming_patch.mapper.dart';

@immutable
class FarmingPatch {
  const FarmingPatch({
    @required this.id,
    @required this.plantedAt,
    @required this.produceId,
    this.produce,
  })  : assert(id != null),
        assert(plantedAt != null),
        assert(produceId != null);

  static FarmingPatch fromMap(Map<String, dynamic> map) => parse(map);

  /// Unique id for storage
  final int id;

  /// Plant time
  final DateTime plantedAt;

  /// Foreign key for produce
  final int produceId;

  /// Many to one relation
  final Produce produce;

  FarmingPatch copyWith({
    int id,
    DateTime plantedAt,
    int produceId,
    Produce produce,
  }) {
    return new FarmingPatch(
      id: id ?? this.id,
      plantedAt: plantedAt ?? this.plantedAt,
      produceId: produceId ?? this.produceId,
      produce: produce ?? this.produce,
    );
  }

  Map<String, dynamic> toMap() => mapify(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FarmingPatch &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            plantedAt == other.plantedAt &&
            produceId == other.produceId &&
            produce == other.produce;
  }

  @override
  int get hashCode {
    return hashValues(
      id,
      plantedAt,
      produceId,
      produce,
    );
  }

  @override
  String toString() {
    return 'FarmingPatch{'
        'id: $id, '
        'plantedAt: $plantedAt, '
        'produceId: $produceId, '
        'produce: $produce'
        '}';
  }
}
