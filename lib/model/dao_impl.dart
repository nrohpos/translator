abstract class DaoImpl<T> {
  Future<List<T>> selectAll();

  Future<T> selectFirst();

  Future<int> delete( String where);

  Future<int> update(dynamic data, String where);

  Future<int> insertInto(dynamic data);

  Future<List<T>> rawQuery({required String sql});


  Future<int?> upsert(dynamic data, String? where);

  Future<bool> isEmpty();

  String get tableName;
}
