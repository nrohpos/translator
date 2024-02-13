import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static String databaseName = "translator";
  static DatabaseHelper shared = DatabaseHelper();
}