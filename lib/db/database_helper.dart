

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static String databaseName = "translator";
  static DatabaseHelper shared = DatabaseHelper();


  void openConnectionDB() async {
    final db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      'translator.db',
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE localize(id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}