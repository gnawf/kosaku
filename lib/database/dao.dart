import 'dart:async';

import 'package:app/database/database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;

typedef T Parser<T>(Map<String, dynamic> map);

typedef Map<String, dynamic> Mapifier<T>(T t);

abstract class Dao<Type> extends ChangeNotifier {
  Dao(
    this._tableName,
    this._database,
    this._parser,
    this._mapifier,
  )   : assert(_tableName != null),
        assert(_database != null),
        assert(_parser != null),
        assert(_mapifier != null);

  /// The name of the table to query
  final String _tableName;

  /// Database to access
  final Database _database;

  /// Converter from Map -> Type
  final Parser<Type> _parser;

  /// Converter from Type -> Map
  final Mapifier<Type> _mapifier;

  Future<Null> upsert(Type object) async {
    await _database.insert(
      _tableName,
      _mapifier(object),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyListeners();
  }

  Future<List<Type>> query({
    Map<String, dynamic> where,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset,
  }) async {
    final results = await _database.query(
      _tableName,
      where: _where(where),
      whereArgs: _whereArgs(where),
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return results.map(_parser).toList();
  }

  Future<Null> delete({Map<String, dynamic> where}) async {
    await _database.delete(
      _tableName,
      where: _where(where),
      whereArgs: _whereArgs(where),
    );

    notifyListeners();
  }

  String _where(Map<String, dynamic> where) {
    if (where == null) {
      return null;
    }

    final output = new List(where.length);

    int index = 0;
    where.forEach((key, value) {
      if (value is List) {
        output[index] = '$key IN (${'?,' * (value.length - 1)}?)';
      } else {
        output[index] = '$key = ?';
      }

      index++;
    });

    return output.join(',');
  }

  List<dynamic> _whereArgs(Map<String, dynamic> where) {
    if (where == null) {
      return null;
    }

    var output = <dynamic>[];

    where.values.forEach((value) {
      if (value is List) {
        output.addAll(value);
      } else {
        output.add(value);
      }
    });

    return output;
  }
}
