import 'dart:async';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String _databaseName = "translator";
  final String tableName = "localize";
  static DatabaseHelper shared = DatabaseHelper();
  late Database _db;

  void openConnectionDB() async {
    _db = await openDatabase(
      _databaseName,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS $tableName(id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // db.execute(
        //   'CREATE TABLE IF NOT EXISTS $tableName(id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
        // );
      },
      version: 1,
    );
    // final result = await _db.rawQuery("drop table $tableName");
    // final result = await _db.query(tableName);
    // print(result);
  }

  Future<int> interData({dynamic data, required String toTable}) async {
    return _db.transaction((txn) async {
      final id = txn.insert(toTable, data);
      return id;
    });
  }

  Future<void> resetDB() async {
    print("Run reset");
    await _db.transaction((txn) async {
      txn.rawQuery("drop table $tableName");
    });

    return await _db.execute(
      'CREATE TABLE IF NOT EXISTS $tableName(id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
    );
  }

  Future<List<Map<String, Object?>>> getAllFor(String lang) async {
    final sql = "select * from $tableName where locale = '$lang'";
    return rawQuery(sql);
  }

  Future<List<Map<String, Object?>>> getLanguages() async {
    final sql = "select * from $tableName group by locale";
    return await rawQuery(sql);
  }

  Future<bool> isTableEmpty({required String tableName}) async {
    final result = await _db.query(tableName);
    return result.isEmpty;
  }

  Future<List<Map<String, Object?>>> rawQuery(String sql) async {
    print(sql);
    final result = await _db.rawQuery(sql);
    print(result);
    return result;
  }

  Future<int> delete(String tbName, String where) async {
    return await _db.delete(tbName, where: where);
  }

}
