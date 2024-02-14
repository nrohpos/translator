import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:translator/language/language.dart';

import 'keyword.dart';

class LanguageViewModel extends GetxController {
  final items = <KeyWord>[].obs;
  final showLoading = false.obs;
  final currentLanguage = Language.kh.obs;

  Future<List<Language>> getLanguage() async {
    final list = Language.values;
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
    final String response = await rootBundle
        .loadString('assets/json/${language.getFileName()}.json');
    final data = await json.decode(response) as Map<String, dynamic>;
    update();
    await Future.delayed(const Duration(seconds: 2));
    showLoading(false);
    currentLanguage(language);
    items.assignAll(data.entries
        .map((e) => KeyWord.init(key: e.key, value: e.value))
        .toList());
    update();
  }
}
