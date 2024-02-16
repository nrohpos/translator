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
      await txn.batch().commit(continueOnError: true);
      return id;
    });
  }

  Future<void> resetDB() async {
    await _db.transaction((txn) async {
      txn.rawQuery("drop table $tableName");
    });

    return await _db.execute(
      'CREATE TABLE IF NOT EXISTS $tableName(id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
    );
  }

  Future<List<Map<String, Object?>>> getAllFor(String lang) async {
    final sql = "select * from $tableName where localize = '$lang'";
    print(sql);
    return await _db.rawQuery(sql);
  }
}
