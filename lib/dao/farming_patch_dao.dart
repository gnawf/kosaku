import 'dart:async';

import 'package:app/database/dao.dart';
import 'package:app/database/database.dart';
import 'package:app/models/farming_patch.dart';
import 'package:app/models/produce.dart';
import 'package:app/tables/farming_patch_table.dart';
import 'package:meta/meta.dart';

Map<String, dynamic> _mapify(FarmingPatch patch) => patch.toMap();

FarmingPatch _parse(Map<String, dynamic> map) => FarmingPatch.fromMap(map);

class FarmingPatchDao extends Dao<FarmingPatch> {
  FarmingPatchDao({
    @required Database database,
    this.produceDao,
  })  : assert(database != null),
        super(FarmingPatchTable.name, database, _parse, _mapify);

  final Dao<Produce> produceDao;

  @override
  Future<List<FarmingPatch>> query({
    Map<String, dynamic> where,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset,
  }) async {
    final results = await super.query(
      where: where,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    await _join(results);

    return results;
  }

  Future<Null> _join(List<FarmingPatch> items) async {
    // Collect the foreign keys for the query
    final fks = items.map((e) => e.produceId).toList(growable: false);

    // Store the queried objects in a lookup table for quick access
    final lookup = <int, Produce>{};

    final query = await produceDao.query(where: {'id': fks});

    for (final object in query) {
      lookup[object.id] = object;
    }

    // Complete the join by attaching the queried object
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      items[i] = item.copyWith(produce: lookup[item.produceId]);
    }
  }
}
