import 'package:get/get.dart';
import 'package:translator/db/database_helper.dart';
import 'package:translator/language/language.dart';

import 'keyword.dart';

class LanguageViewModel extends GetxController {
  final items = <KeyWord>[].obs;
  final showLoading = false.obs;
  final currentLanguage = Language.kh.obs;

  Future<List<Language>> getLanguage() async {
    const list = Language.values;
    await Future.delayed(
      const Duration(seconds: 1),
    );
    currentLanguage(list.first);
    getKeyword(language: currentLanguage.value, first: true);
    return Future(() => list);
  }

  Future<void> getKeyword({
    required Language language,
    bool first = false,
  }) async {
    if (currentLanguage.value == language && !first) {
      return;
    }
    showLoading(true);
    final data =
        await DatabaseHelper.shared.getAllFor(language.name.toUpperCase());

    update();
    await Future.delayed(const Duration(seconds: 2));
    showLoading(false);
    currentLanguage(language);
    items.assignAll(data
        .map((e) =>
            KeyWord.init(key: e["key"] as String, value: e["value"] as String))
        .toList());
    update();
  }
}
