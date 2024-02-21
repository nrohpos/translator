import 'package:get/get.dart';
import 'package:translator/db/database_helper.dart';

import 'keyword.dart';

class LanguageViewModel extends GetxController {
  final items = <KeyWord>[].obs;
  final showLoading = false.obs;
  final currentLanguage = "".obs;

  Future<List<String?>> getLanguage() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    final result = await DatabaseHelper.shared.getLanguages();
    final list = result.map((e) => e["locale"] as String?).toList();
    currentLanguage(list.first);
    getKeyword(language: currentLanguage.value, first: true);
    return Future(() => list);
  }

  Future<void> getKeyword({
    required String language,
    bool first = false,
  }) async {
    if (currentLanguage.value == language && !first) {
      return;
    }
    showLoading(true);
    update();
    final data = await DatabaseHelper.shared.getAllFor(language);

    currentLanguage(language);
    items.assignAll(data
        .map((e) =>
            KeyWord.init(key: e["key"] as String, value: e["value"] as String))
        .toList());
    showLoading(false);
    update();
  }
}
