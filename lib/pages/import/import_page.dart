import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:translator/pages/import/import_vm.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final viewModel = Get.put(ImportViewModel());
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.openConnectionDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "Import File",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<ImportViewModel>(
        init: viewModel,
        builder: (vm) {
          return Container(
            child: vm.isDataEmpty.isTrue
                ? GestureDetector(
                    child: _ImportFileEmptyView(
                      controller: controller,
                    ),
                    onTap: () async {
                      _getData();
                    },
                  )
                : Text("data exist"),
          );
        },
      ),
    );
  }

  _getData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ["json"],
    );
    if (result != null) {
      File file = File(result.files.first.path!);
      final type = result.files.first.extension;
      if (type == "json") {
        final raw = await file.readAsBytes();
        final jsonData = json.decode(utf8.decode(raw));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("File format is incorrect"),
        ));
      }
    }
  }

  void openConnectionDB() async {
    final db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      'translator.db',
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE IF NOT EXISTS localize(id TEXT PRIMARY KEY, key TEXT , value TEXT, locale CHAR)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}

@immutable
class _ImportFileEmptyView extends StatelessWidget {
  final TextEditingController controller;

  const _ImportFileEmptyView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.greenAccent,
                hintText: "Input Language code",
              ),
              maxLines: 1,
              maxLength: 10,
              textAlign: TextAlign.center,
            ),
            Text('Browse to import \nWith type of json.')
          ],
        ),
      ),
    );
  }
}
