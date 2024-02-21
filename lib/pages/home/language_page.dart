import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:translator/extension/string+extension.dart';
import 'package:translator/model/keyword/keyword.dart';
import 'package:translator/pages/home/loading_state_view.dart';
import 'package:translator/utils/views/vertical_splitview.dart';

import '../../model/language/language.dart';
import '../../utils/views/expandable_floating.dart';
import 'language_vm.dart';
import 'localize_list_view.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late LanguageViewModel viewModel = Get.put(LanguageViewModel());

  @override
  Widget build(BuildContext context) {
    print("ahksdfbjhasdfasd ${MediaQuery.of(context).size.width}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Language",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Language>>(
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              final items = snapshot.data ?? [];
              return GetBuilder<LanguageViewModel>(
                builder: (vm) {
                  return VerticalSplitView(
                    left: ListView.builder(
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isSelect = vm.currentLanguage.value == item;
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          title: Text(
                            item.name.orEmpty,
                          ),
                          tileColor: Colors.white,
                          onTap: () async {
                            await vm.getKeyword(language: item);
                          },
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                          ),
                          selectedColor: Colors.cyanAccent,
                          selected: isSelect,
                        );
                      },
                      itemCount: items.length,
                    ),
                    right: vm.showLoading.isTrue
                        ? const LoadingStateView()
                        : LocalizeListView(
                            items: vm.items,
                            onEdit: (keyWord) {
                              showEdit(keyWord);
                            },
                          ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
          future: viewModel.getLanguage(),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.language),
          ),
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.import_export),
          ),
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }

  showEdit(KeyWord keyWord) {
    final keyController = TextEditingController(text: keyWord.key);
    final valueController = TextEditingController(text: keyWord.value);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              margin: EdgeInsets.all(Get.width * 0.04),
              padding: EdgeInsets.all(Get.width * 0.04),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: keyController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.greenAccent,
                            hintText: "Key",
                          ),
                          maxLines: 1,
                          maxLength: 10,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.04,
                      ),
                      Expanded(
                        child: TextField(
                          controller: valueController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.greenAccent,
                            hintText: "Value",
                          ),
                          maxLines: 1,
                          maxLength: 10,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
