import 'farming_patch.dart';

Map<String, dynamic> mapify(FarmingPatch patch) {
  return {
    'id': patch.id,
    'plantedAt': patch.plantedAt.toIso8601String(),
    'produceId': patch.produceId,
  };
}

FarmingPatch parse(Map<String, dynamic> map) {
  return new FarmingPatch(
    id: map['id'],
    plantedAt: DateTime.parse(map['plantedAt']),
    produceId: map['produceId'],
  );
}
