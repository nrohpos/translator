import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/pages/Home/home_page.dart';
import 'package:translator/pages/language/language_vm.dart';

import '../../language/language.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

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
        child: GetBuilder<LanguageViewModel>(
          init: LanguageViewModel(),
          builder: (vm) {
            return FutureBuilder<List<Language>>(
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  final items = snapshot.data ?? [];
                  return ListView.builder(
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          title: Text(
                            item.getName(),
                          ),
                          tileColor: Colors.white,
                          onTap: () {
                            Get.toNamed("/home");
                          },
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        );
                      },
                      itemCount: items.length);
                }
                return Container();
              },
              future: vm.getLanguage(),
            );
          },
        ),
      ),
    );
  }
}
