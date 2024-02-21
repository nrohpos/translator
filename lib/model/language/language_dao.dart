import 'package:translator/model/base_dao.dart';
import 'package:translator/model/language/language.dart';

class LanguageDao extends BaseDao<Language> {
  Future<List<Language>> getLanguages() async {
    final sql = "select * from $tableName group by locale";
    return rawQuery(sql: sql);
  }
}
