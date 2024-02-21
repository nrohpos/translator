import 'package:translator/db/database_helper.dart';
import 'package:translator/model/dao_impl.dart';

import 'object_wrapper.dart';
import 'package:collection/collection.dart';

class BaseDao<T> implements DaoImpl<T> {
  final _dbHelper = DatabaseHelper.shared;

  @override
  String get tableName => "localize";

  @override
  Future<int> insertInto(data) async {
    final rowId = await _dbHelper.interData(data: data, toTable: tableName);
    return rowId;
  }

  @override
  Future<bool> isEmpty() async {
    final result = await selectAll();
    return result.isEmpty;
  }

  @override
  Future<List<T>> rawQuery({required String sql}) async {
    final result = await _dbHelper.rawQuery(sql);
    return result.map((e) {
      return ObjectWrapper.fromMap<T>(e);
    }).toList();
  }

  @override
  Future<List<T>> selectAll() async {
    final result = await _dbHelper.rawQuery("select * from $tableName");
    return result.map((e) {
      return ObjectWrapper.fromMap<T>(e);
    }).toList();
  }

  @override
  Future<T> selectFirst() async {
    final result = await selectAll();
    return result.first;
  }

  @override
  Future<int> delete(String where) async {
    final result = await _dbHelper.delete(tableName, where);
    return result;
  }

  @override
  Future<int> update(data, String where) async {
    final result = await _dbHelper.update(tableName, data, where);
    return result;
  }

  @override
  Future<int?> upsert(data, String? where) async {
    if (where == null) {
      return this.insertInto(data);
    }
    return update(data, where);
  }
}
