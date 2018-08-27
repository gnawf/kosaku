import 'dart:async';

import 'package:app/database/database.dart';

abstract class DatabaseTable {
  Future<Null> create(Database db, int version);

  Future<Null> upgrade(Database db, int oldVersion, int newVersion);
}
