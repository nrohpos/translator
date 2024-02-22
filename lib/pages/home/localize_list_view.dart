import 'package:flutter/material.dart';
import 'package:translator/pages/Home/header_type.dart';
import 'package:translator/pages/home/event_action.dart';
import 'package:translator/pages/home/language_vm.dart';

import '../../model/keyword/keyword.dart';

class LocalizeListView extends StatelessWidget {
  final List<KeyWord> items;
  final Function(KeyWord) onEdit;
  final Function(EventAction) onEventAction;

  const LocalizeListView({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onEventAction,
  });

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
                          DataCell(Text(e.key), showEditIcon: true, onTap: () {
                            onEdit(e);
                          }),
                          DataCell(Text(e.value), showEditIcon: true,
                              onTap: () {
                            onEdit(e);
                          }),
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
                  child: GestureDetector(
                    onTap: () {
                      onEventAction(EventAction.create);
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: const Text("Create")),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onEventAction(EventAction.export);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 56,
                      child: Center(child: const Text("Export")),
                    ),
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
