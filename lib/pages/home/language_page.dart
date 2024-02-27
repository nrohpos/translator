import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/extension/string+extension.dart';
import 'package:translator/model/keyword/keyword.dart';
import 'package:translator/pages/home/loading_state_view.dart';
import 'package:translator/utils/views/vertical_splitview.dart';

import '../../model/language/language.dart';
import '../../utils/views/expandable_floating.dart';
import 'event_action.dart';
import 'language_vm.dart';
import 'localize_list_view.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late LanguageViewModel viewModel = Get.put(LanguageViewModel());
  final searchController = TextEditingController();
  late Function(EventAction) onEventAction = (action) async {
    if (action == EventAction.create) {
      KeyWord keyword = KeyWord.init();
      showEdit(keyword);
    } else if (action == EventAction.export) {
      final path = await viewModel.exportFile();
      if (path.isNotEmpty && mounted) {
        dialogBuilder(context, path);
      }
    }
  };

  @override
  Widget build(BuildContext context) {
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
                        : Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: SearchBar(
                                  hintText: "Search",
                                  controller: searchController,
                                  onChanged: (str) {
                                    viewModel.onFilterItems(str.toLowerCase());
                                  },
                                  trailing: [
                                    ActionButton(
                                      onPressed: () => {
                                        searchController.text = "",
                                        viewModel.onFilterItems(""),
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: LocalizeListView(
                                  items: vm.items,
                                  onEdit: (keyWord) {
                                    showEdit(keyWord);
                                  },
                                  onEventAction: onEventAction,
                                ),
                              )
                            ],
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
        return GestureDetector(
          onTap: () {
            navigator?.pop();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(Get.width * 0.04),
                padding: EdgeInsets.all(Get.width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
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
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            navigator?.pop();
                            keyWord.key = keyController.text;
                            keyWord.value = valueController.text;
                            viewModel.upSertKeyword(keyWord);
                          },
                          style: TextButton.styleFrom(
                            minimumSize: const Size(120, 56),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              side: BorderSide(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Submit",
                          ),
                        ),
                        Spacer(),
                        if (keyController.text.isNotEmpty &&
                            valueController.text.isNotEmpty)
                          TextButton(
                            onPressed: () async {
                              navigator?.pop();
                              viewModel.deleteKeyword(keyWord);
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size(120, 56),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                side: BorderSide(
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Delete",
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> dialogBuilder(BuildContext context, String path) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(
            'File has been saved in \n$path.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
