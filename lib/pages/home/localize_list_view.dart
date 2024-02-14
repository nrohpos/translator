import 'package:flutter/material.dart';

import 'package:translator/pages/Home/header_type.dart';

import 'keyword.dart';

class LocalizeListView extends StatelessWidget {
  final List<KeyWord> items;

  const LocalizeListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          DataTable(
              columns: HeaderType.values
                  .map(
                    (e) => DataColumn(
                      label: Text(
                        e.getName(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: items.map(
                (e) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(e.key),
                      ),
                      DataCell(
                        Text(e.value),
                      ),
                    ],
                  );
                },
              ).toList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
