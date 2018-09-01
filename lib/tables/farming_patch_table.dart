import 'dart:async';

import 'package:app/database/database.dart';
import 'package:app/database/database_table.dart';

import 'produce_table.dart';

class FarmingPatchTable extends DatabaseTable {
  static const name = 'patches';

  @override
  Future<Null> create(Database db, int version) async {
    await db.execute('CREATE TABLE $name ('
        'id INTEGER PRIMARY KEY,'
        'plantedAt TEXT NOT NULL,'
        'produceId INTEGER NOT NULL,'
        'FOREIGN KEY(produceId) REFERENCES ${ProduceTable.name}(id)'
        ')');
  }

  @override
  Future<Null> upgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      create(db, newVersion);
    }
  }
}
