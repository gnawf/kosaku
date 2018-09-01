import 'package:app/dao/farming_patch_dao.dart';
import 'package:app/dao/produce_dao.dart';
import 'package:app/database/dao.dart';
import 'package:app/database/database.dart';
import 'package:app/database/database_table.dart';
import 'package:app/inject/inject.dart';
import 'package:app/inject/injector.dart';
import 'package:app/models/farming_patch.dart';
import 'package:app/models/produce.dart';
import 'package:app/tables/farming_patch_table.dart';
import 'package:app/tables/produce_table.dart';
import 'package:flutter/material.dart';

class DatabaseInjector extends Injector {
  DatabaseInjector({
    @required Widget child,
  }) : super(child: child, bootstrap: bootstrap);
}

void bootstrap(Inject inject) {
  inject.register(factory: _tables, singleton: true);
  inject.register(factory: _database, singleton: true);
  inject.register(factory: _produceDao, singleton: true);
  inject.register(factory: _farmingPatchDao, singleton: true);
}

List<DatabaseTable> _tables(Inject inject) {
  return [
    ProduceTable(),
    FarmingPatchTable(),
  ];
}

Database _database(Inject inject) {
  return new Database(
    name: 'kosaku',
    version: 2,
    tables: inject.get(),
  );
}

Dao<Produce> _produceDao(Inject inject) {
  return ProduceDao(
    database: inject.get(),
  );
}

Dao<FarmingPatch> _farmingPatchDao(Inject inject) {
  return FarmingPatchDao(
    database: inject.get(),
    produceDao: inject.get(),
  );
}
