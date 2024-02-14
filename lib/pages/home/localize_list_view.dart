import 'package:flutter/material.dart';
import 'package:translator/pages/Home/header_type.dart';

import 'keyword.dart';

class LocalizeListView extends StatelessWidget {
  final List<KeyWord> items;

  const LocalizeListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Expanded(
              child: ListView(
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
                          DataCell(Text(e.key),
                              showEditIcon: true, onTap: () {}),
                          DataCell(Text(e.value),
                              showEditIcon: true, onTap: () {}),
                        ],
                      );
                    },
                  ).toList()),
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    height: 56,
                    color: Colors.cyanAccent,
                    onPressed: () {},
                    child: const Text("Add"),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {},
                    color: Colors.cyanAccent,
                    height: 56,
                    child: const Text("Export"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
