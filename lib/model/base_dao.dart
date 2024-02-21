import 'package:translator/db/database_helper.dart';
import 'package:translator/model/dao_impl.dart';

import 'object_wrapper.dart';
import 'package:collection/collection.dart';

class BaseDao<T> implements DaoImpl<T> {
  final _dbHelper = DatabaseHelper.shared;

  @override
  String get tableName => "localize";

  @override
  Future<int> insertInto(T item) {
    // TODO: implement insertInto
    throw UnimplementedError();
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
  Future<int> delete(T item, String where) async {
    final result = await _dbHelper.delete(tableName, where);
    return result;
  }

  @override
  Future<T> update(T item, String where) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<T> upsert(T item, String? where) {
    // TODO: implement upsert
    throw UnimplementedError();
  }
}
