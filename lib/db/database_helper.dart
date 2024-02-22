import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:translator/model/keyword/keyword_dao.dart';

class DatabaseHelper {
  final String _databaseName = "translator";
  static DatabaseHelper shared = DatabaseHelper();
  late Database _db;
  int countTable = 0;
  bool _isKeywordEmpty = true;

  bool get isDatabaseEmpty => _isKeywordEmpty;

  void openConnectionDB() async {
    _db = await openDatabase(
      _databaseName,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS localize (id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
        ); // create table with in here
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // db.execute(
        //   'CREATE TABLE IF NOT EXISTS $tableName(id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
        // );
      },
      version: 1,
    );
    final items = await KeyWordDao().selectAll();
    _isKeywordEmpty = items.isEmpty;
    countTable = await countTables();

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

  Future<void> resetDB({String tableName = "localize"}) async {
    print("Run reset");
    await _db.transaction((txn) async {
      txn.rawQuery("drop table $tableName");
    });

    await _db.execute(
      'CREATE TABLE IF NOT EXISTS $tableName(id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
    );

    final items = await KeyWordDao().selectAll();
    _isKeywordEmpty = items.isEmpty;
    countTable = await countTables();
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

  Future<int> update(String tbName, dynamic data, String where) async {
    return await _db.update(tbName, data, where: where);
  }

  Future<int> countTables() async {
    var sql = "SELECT COUNT(*) FROM sqlite_master WHERE type='table'";
    final result = await _db.rawQuery(sql);
    return result.length;
  }
}
