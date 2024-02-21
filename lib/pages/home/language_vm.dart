import 'package:get/get.dart';
import 'package:translator/db/database_helper.dart';
import 'package:translator/extension/string+extension.dart';
import 'package:translator/model/keyword/keyword_dao.dart';
import 'package:translator/model/language/language.dart';
import 'package:translator/model/language/language_dao.dart';

import '../../model/keyword/keyword.dart';

class LanguageViewModel extends GetxController {
  final items = <KeyWord>[].obs;
  final showLoading = false.obs;
  final currentLanguage = Language.init().obs;
  final _keyWordDao = KeyWordDao();
  final _languageDao = LanguageDao();

  Future<List<Language>> getLanguage() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    final result = await _languageDao.getLanguages();
    currentLanguage(result.first);
    getKeyword(language: currentLanguage.value, first: true);
    return Future(() => result);
  }

  Future<void> getKeyword({
    required Language language,
    bool first = false,
  }) async {
    if (currentLanguage.value == language && !first) {
      return;
    }
    showLoading(true);
    update();
    final data = await _keyWordDao.getAllFor(language.name.orEmpty);
    currentLanguage(language);
    items.assignAll(data);
    showLoading(false);
    update();
  }
}
