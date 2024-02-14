import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/pages/home/loading_state_view.dart';
import 'package:translator/utils/views/vertical_splitview.dart';

import '../../language/language.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
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
                          print("alksjdkfjksdfds${isSelect} , ${item.getName()}");
                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            title: Text(
                              item.getName(),
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
                        itemCount: items.length),
                    right: vm.showLoading.isTrue
                        ? const LoadingStateView()
                        : LocalizeListView(items: vm.items),
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
    );
  }
}
