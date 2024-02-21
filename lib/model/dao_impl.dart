abstract class DaoImpl<T> {
  Future<List<T>> selectAll();

  Future<T> selectFirst();

  Future<int> delete(T item, String where);

  Future<T> update(T item, String where);

  Future<int> insertInto(T item);

  Future<List<T>> rawQuery({required String sql});


  Future<T> upsert(T item, String? where);

  Future<bool> isEmpty();

  String get tableName;
}
