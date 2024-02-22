import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:translator/db/database_helper.dart';
import 'package:translator/model/keyword/keyword_dao.dart';
import 'package:uuid/uuid.dart';

class ImportViewModel extends GetxController {
  var isSyncData = false.obs;
  var indicatorAmount = 0.0.obs;
  var isSyncSuccess = false.obs;
  var isDatabaseEmpty = DatabaseHelper.shared.isDatabaseEmpty.obs;


  Future<bool> checkData() async {
    return await DatabaseHelper.shared.isTableEmpty(tableName: "localize");
  }

  Future<void> getData(String language) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ["json"],
    );
    if (result != null) {
      File file = File(result.files.first.path!);
      final type = result.files.first.extension;
      if (type == "json") {
        final raw = await file.readAsBytes();
        Map<String, dynamic> jsonData = json.decode(utf8.decode(raw));
        isSyncData.value = true;
        update();
        syncData(jsonData, language);
      }
    }
  }

  Future<void> syncData(Map<String, dynamic> data, String language) async {
    final maxLength = data.length;
    data.forEach((key, value) async {
      final rowId = await DatabaseHelper.shared.interData(
        toTable: KeyWordDao().tableName,
        data: {
          'id': const Uuid().v4(),
          'key': key,
          'value': value,
          'locale': language
        },
      );
      if (rowId > 0) {
        final percentage = rowId * 100 / maxLength;
        indicatorAmount.value = percentage / 100;
        isSyncSuccess.value = percentage >= 100;
        update();
      }
    });
  }

  Future<void> resetDB() async {
    await DatabaseHelper.shared.resetDB();
  }
}
