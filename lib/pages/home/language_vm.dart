import 'dart:io';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translator/extension/string+extension.dart';
import 'package:translator/model/keyword/keyword_dao.dart';
import 'package:translator/model/language/language.dart';
import 'package:translator/model/language/language_dao.dart';
import '../../model/keyword/keyword.dart';

class LanguageViewModel extends GetxController {
  final _totalItems = <KeyWord>[].obs;
  RxList<KeyWord> items = <KeyWord>[].obs;
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
    _totalItems.assignAll(data);
    items.assignAll(_totalItems);
    showLoading(false);
    update();
  }

  Future<void> upSertKeyword(KeyWord keyWord) async {
    showLoading(true);
    update();
    // find localize list and update
    var found = false;
    var list = _totalItems
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
      await _keyWordDao.insertInto(keyWord.toJson());
    } else {
      // update
      String where = "id = '${keyWord.id}'";
      await _keyWordDao.update(keyWord.toJson(), where);
    }

    _totalItems.assignAll(list);
    items.assignAll(_totalItems);
    showLoading(false);
    update();
  }

  Future<void> deleteKeyword(KeyWord keyWord) async {
    showLoading(true);
    update();

    final result = await _keyWordDao.delete("id = '${keyWord.id}'");
    if (result > 0) {
      _totalItems.removeWhere(
              (element) => element.id.toLowerCase() == keyWord.id.toLowerCase());
      items.assignAll(_totalItems);
    }
    showLoading(false);
    update();
  }

  Future<String> exportFile() async {
    final item =
        '{${_totalItems.map((element) => element.export()).join(" , ")}}';
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
      final file = await File('$userPath${currentLanguage.value.name}.json')
          .create(recursive: true);
      final fileLocalize = await file.writeAsString(item);
      return fileLocalize.path;
    }
    return "";
  }

  Future<void> onFilterItems(String filter) async {
    var result = <KeyWord>[];
    if (filter.isEmpty) {
      // reset items
      result = _totalItems;
    } else {
      result = _totalItems.where((element) {
        return element.key.toLowerCase().contains(filter) ||
            element.value.toLowerCase().contains(filter);
      }).toList();
    }
    items.assignAll(result);
    update();
  }
}
