import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:translator/db/database_helper.dart';
import 'package:translator/pages/import/import_error_type.dart';
import 'package:uuid/uuid.dart';

class ImportViewModel extends GetxController {
  var isDataEmpty = true.obs;
  var isSyncData = false.obs;
  var indicatorAmount = 0.0.obs;
  var isSyncSuccess = false.obs;

  Future<ImportErrorType> getData(String language) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ["json"],
    );
    if (result != null) {
      File file = File(result.files.first.path!);
      final type = result.files.first.extension;
      if (type == "json") {
        final raw = await file.readAsBytes();
        Map<String, dynamic> jsonData = json.decode(utf8.decode(raw));
        syncData(jsonData, language);
        isSyncData.value = true;
        update();
        return ImportErrorType.success;
      }
    }
    return ImportErrorType.wrongFormat;
  }

  void syncData(Map<String, dynamic> data, String language) {
    final maxLength = data.length;
    data.forEach((key, value) async {
      final rowId = await DatabaseHelper.shared.interData(
        toTable: DatabaseHelper.shared.tableName,
        data: {
          'id': const Uuid().v4(),
          'key': key,
          'value': value,
          'locale': language
        },
      );
      if (rowId > 0) {
        final percentage = rowId * 100 / maxLength;
        indicatorAmount.value = percentage;
        isSyncSuccess.value = percentage == 100;
        update();
      }
    });
  }
}
