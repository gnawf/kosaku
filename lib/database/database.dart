import 'dart:async';

import 'package:app/database/database_table.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as paths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:synchronized/synchronized.dart';

/// Wrapper around sqflite to provide an injectable dependency without async
///
/// The class interface matches [DatabaseExecutor]
class Database {
  Database({
    sql.Database database,
    @required this.name,
    @required this.version,
    @required this.tables,
  })  : assert(name != null),
        assert(version != null),
        assert(tables != null),
        _database = database;

  final String name;

  final int version;

  final List<DatabaseTable> tables;

  final _openLock = new Lock();

  /// Do not use directly, use [_open]
  sql.Database _database;

  Future<sql.Database> _open() async {
    if (_database == null) {
      await _openLock.synchronized(() async {
        if (_database == null) {
          var databasesPath = await sql.getDatabasesPath();
          String path = paths.join(databasesPath, '$name.db');
          _database = await sql.openDatabase(
            path,
            version: version,
            onCreate: _create,
            onUpgrade: _upgrade,
          );
        }
      });
    }
    return _database;
  }

  Future<Null> _create(sql.Database db, int version) async {
    Database wrapped = Database(
      name: name,
      database: db,
      version: version,
      tables: [],
    );
    for (final table in tables) {
      await table.create(wrapped, version);
    }
  }

  Future<Null> _upgrade(sql.Database db, int oldVersion, int newVersion) async {
    Database wrapped = Database(
      name: name,
      database: db,
      version: version,
      tables: [],
    );
    for (final table in tables) {
      await table.upgrade(wrapped, oldVersion, newVersion);
    }
  }

  /// for sql without return values
  Future execute(String sql, [List arguments]) async {
    return (await _open()).execute(sql, arguments);
  }

  /// for INSERT sql query
  /// returns the last inserted record id
  Future<int> rawInsert(String sql, [List arguments]) async {
    return (await _open()).rawInsert(sql, arguments);
  }

  /// INSERT helper
  Future<int> insert(String table, Map<String, dynamic> values,
      {String nullColumnHack, sql.ConflictAlgorithm conflictAlgorithm}) async {
    return (await _open()).insert(
      table,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Helper to query a table
  ///
  /// @param distinct true if you want each row to be unique, false otherwise.
  /// @param table The table names to compile the query against.
  /// @param columns A list of which columns to return. Passing null will
  ///            return all columns, which is discouraged to prevent reading
  ///            data from storage that isn't going to be used.
  /// @param where A filter declaring which rows to return, formatted as an SQL
  ///            WHERE clause (excluding the WHERE itself). Passing null will
  ///            return all rows for the given URL.
  /// @param groupBy A filter declaring how to group rows, formatted as an SQL
  ///            GROUP BY clause (excluding the GROUP BY itself). Passing null
  ///            will cause the rows to not be grouped.
  /// @param having A filter declare which row groups to include in the cursor,
  ///            if row grouping is being used, formatted as an SQL HAVING
  ///            clause (excluding the HAVING itself). Passing null will cause
  ///            all row groups to be included, and is required when row
  ///            grouping is not being used.
  /// @param orderBy How to order the rows, formatted as an SQL ORDER BY clause
  ///            (excluding the ORDER BY itself). Passing null will use the
  ///            default sort order, which may be unordered.
  /// @param limit Limits the number of rows returned by the query,
  /// @param offset starting index,
  /// @return the items found
  Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct,
      List<String> columns,
      String where,
      List whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    return (await _open()).query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// for SELECT sql query
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List arguments]) async {
    return (await _open()).rawQuery(sql, arguments);
  }

  /// for UPDATE sql query
  /// return the number of changes made
  Future<int> rawUpdate(String sql, [List arguments]) async {
    return (await _open()).rawUpdate(sql, arguments);
  }

  /// Convenience method for updating rows in the database.
  ///
  /// update into table [table] with the [values], a map from column names
  /// to new column values. null is a valid value that will be translated to NULL.
  /// [where] is the optional WHERE clause to apply when updating.
  ///            Passing null will update all rows.
  /// You may include ?s in the where clause, which
  ///            will be replaced by the values from [whereArgs]
  /// optional [conflictAlgorithm] for update conflict resolver
  /// return the number of rows affected
  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List whereArgs,
      sql.ConflictAlgorithm conflictAlgorithm}) async {
    return (await _open()).update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// for DELETE sql query
  /// return the number of changes made
  Future<int> rawDelete(String sql, [List arguments]) async {
    return (await _open()).rawDelete(sql, arguments);
  }

  /// Convenience method for deleting rows in the database.
  ///
  /// delete from [table]
  /// [where] is the optional WHERE clause to apply when updating.
  ///            Passing null will update all rows.
  /// You may include ?s in the where clause, which
  ///            will be replaced by the values from [whereArgs]
  /// optional [conflictAlgorithm] for update conflict resolver
  /// return the number of rows affected if a whereClause is passed in, 0
  ///         otherwise. To remove all rows and get a count pass "1" as the
  ///         whereClause.
  Future<int> delete(String table, {String where, List whereArgs}) async {
    return (await _open()).delete(table, where: where, whereArgs: whereArgs);
  }

  /// Creates a batch, used for performing multiple operation
  /// in a single atomic operation.
  ///
  /// a batch can be commited using [Batch.commit]
  ///
  /// If the batch was created in a transaction, it will be commited
  /// when the transaction is done
  Future<sql.Batch> batch() async {
    return (await _open()).batch();
  }
}
