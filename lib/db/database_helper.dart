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
      onUpgrade: (db, oldVersion, newVersion) {},
      version: 1,
    );
  }

  Future<int> interData({dynamic data, required String toTable}) async {
    final row = _db.transaction((txn) async {
      final id = txn.insert(toTable, data);
      await txn.batch().commit(exclusive: true);
      return id;
    });
    return Future(() => row);
  }
}
