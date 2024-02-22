import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<void> upSertKeyword(KeyWord keyWord) async {
    showLoading(true);
    update();
    // find localize list and update
    var found = false;
    var list = items
        .map((element) {
          if (element.id == keyWord.id) {
            element.value = keyWord.value;
            element.key = keyWord.key;
            found = true;
          }
          return element;
        })
        .whereNotNull()
        .toList();

    if (!found) {
      // call inset
      list.insert(0, keyWord);
      final result = await _keyWordDao.insertInto(keyWord.toJson());
      print("insert for row $result");
    } else {
      // update
      String where = "id = '${keyWord.id}'";
      final result = await _keyWordDao.update(keyWord.toJson(), where);
      print("update for row $result");
    }

    items.assignAll(list);
    showLoading(false);
    update();
  }

  Future<void> exportFile() async {
    final item = items.map((element) => element.export()).toString();
    final dir = await getApplicationDocumentsDirectory();
    // var found = false;
    var parentDir = dir.parent;
    List<String> listPath = [];

    while (parentDir.path != "/") {
      parentDir = parentDir.parent;
      String path = parentDir.path;
      final splits = path.split("/");
      splits.removeWhere((element) => element.isEmpty);
      if (splits.length == 2) {
        listPath = splits;
      }
    }
    if (listPath.isNotEmpty) {
      var userPath = "/${listPath.join("/")}/Downloads/";
      final file = await File('$userPath${currentLanguage.value.name}.json').create(recursive: true);
      await file.writeAsString(item);
    }


  }
}
