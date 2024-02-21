import 'package:translator/model/base_dao.dart';
import 'package:translator/model/keyword/keyword.dart';

class KeyWordDao extends BaseDao<KeyWord> {
  @override
  String get tableName => "localize";

  Future<List<KeyWord>> getAllFor(String lang) async {
    final sql = "select * from $tableName where locale = '$lang'";
    return rawQuery(sql: sql);
  }
}
