import 'dart:async';
import 'dart:convert' as convert;

import 'package:app/database/database.dart';
import 'package:app/database/database_table.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProduceTable extends DatabaseTable {
  static const name = 'produce';

  @override
  Future<Null> create(Database db, int version) async {
    await db.execute('CREATE TABLE $name ('
        'id INTEGER PRIMARY KEY,'
        'type INTEGER NOT NULL,'
        'name TEXT NOT NULL,'
        'itemId INTEGER NOT NULL,'
        'tickRate INTEGER NOT NULL,'
        'stages INTEGER NOT NULL,'
        'regrowTickRate INTEGER NOT NULL,'
        'harvestStages INTEGER NOT NULL'
        ')');

    // Populate database
    final json = await rootBundle.loadString('assets/produce.json');
    final data = convert.json.decode(json);
    for (final datum in data) {
      if (datum is Map) {
        await db.insert(name, datum);
      }
    }
  }

  @override
  Future<Null> upgrade(Database db, int oldVersion, int newVersion) async {
    // stub
  }
}
