import 'produce.dart';

Map<String, dynamic> mapify(Produce produce) {
  return {
    'id': produce.id,
    'type': produce.type.index,
    'name': produce.name,
    'itemId': produce.itemId,
    'tickRate': produce.tickRate,
    'stages': produce.stages,
    'regrowTickrate': produce.regrowTickRate,
    'harvestStages': produce.harvestStages,
  };
}

Produce parse(Map<String, dynamic> map) {
  final typeOrdinal = map['type'];

  return Produce(
    id: map['id'],
    type: ProduceType.values[typeOrdinal],
    name: map['name'],
    itemId: map['itemId'],
    tickRate: map['tickRate'],
    stages: map['stages'],
    regrowTickRate: map['regrowTickRate'],
    harvestStages: map['harvestStages'],
  );
}
