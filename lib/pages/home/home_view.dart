import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/pages/home/header_type.dart';
import 'package:translator/pages/home/keyword.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    readJson();
    super.initState();
  }

  List<KeyWord> itemList = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/localizeKh.json');
    final data = await json.decode(response) as Map<String, dynamic>;

    setState(() {
      itemList = data.entries
          .map((e) => KeyWord.init(key: e.key, value: e.value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
          columns: HeaderType.values
              .map((e) => DataColumn(
                      label: Text(
                    e.getName(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )))
              .toList(),
          rows: itemList
              .map((e) => DataRow(
                  cells: [DataCell(Text(e.key)), DataCell(Text(e.value))]))
              .toList()),
    );
  }
}
