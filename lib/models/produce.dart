import 'dart:ui';

import 'package:meta/meta.dart';

import 'produce.mapper.dart';

@immutable
class Produce {
  const Produce({
    @required this.id,
    @required this.type,
    @required this.name,
    @required this.itemId,
    @required this.tickRate,
    @required this.stages,
    this.regrowTickRate = 0,
    this.harvestStages = 1,
  })  : assert(id != null),
        assert(type != null),
        assert(name != null),
        assert(itemId != null),
        assert(tickRate != null),
        assert(stages != null),
        assert(regrowTickRate != null),
        assert(harvestStages != null);

  static Produce fromMap(Map<String, dynamic> value) => parse(value);

  /// Unique id for storage
  final int id;

  /// What type of produce e.g. tree, fruit tree, herb
  final ProduceType type;

  /// User-visible name
  final String name;

  /// User-visible item icon
  final int itemId;

  /// How many minutes per growth tick
  final int tickRate;

  /// How many states this crop has during growth
  final int stages;

  /// How many minutes to regrow crops, or zero if it doesn't regrow
  final int regrowTickRate;

  /// How many states this crop has during harvest.
  /// This is often called lives.
  final int harvestStages;

  /// How many tickRates to pass before produce is ready to harvest
  int get tickCount => stages - 1;

  Map<String, dynamic> toMap() => mapify(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Produce &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            type == other.type &&
            name == other.name &&
            itemId == other.itemId &&
            tickRate == other.tickRate &&
            stages == other.stages &&
            regrowTickRate == other.regrowTickRate &&
            harvestStages == other.harvestStages;
  }

  @override
  int get hashCode {
    return hashValues(
      id,
      name,
      type,
      itemId,
      tickRate,
      stages,
      regrowTickRate,
      harvestStages,
    );
  }

  @override
  String toString() {
    return 'Produce{'
        'id: $id, '
        'type: $type, '
        'name: $name, '
        'itemId: $itemId, '
        'tickRate: $tickRate, '
        'stages: $stages, '
        'regrowTickRate: $regrowTickRate, '
        'harvestStages: $harvestStages'
        '}';
  }
}

enum ProduceType {
  allotment,
  flower,
  hop,
  bush,
  tree,
  fruitTree,
  herb,
  special,
}
