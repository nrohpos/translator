import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/pages/home/language_page.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          "Import File",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<bool>(
        future: viewModel.checkData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data);
            var isEmpty = snapshot.data ?? true;
            return GetBuilder<ImportViewModel>(
              init: viewModel,
              builder: (vm) {
                if (viewModel.isSyncSuccess.isTrue) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.off(() => const LanguagePage());
                  });
                }
                return viewModel.isSyncData.isFalse
                    ? Column(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            child: _ImportFileEmptyView(
                              controller: controller,
                            ),
                            onTap: () async {
                              final language = controller.text.trim();
                              if (language.isNotEmpty) {
                                await viewModel.getData(language);
                                if (viewModel.isSyncSuccess.value) {
                                  Get.off(() => const LanguagePage());
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Column(
                                    children: [
                                      Text('Please enter a language'),
                                      Text(
                                          'Check Data isEmpty >>>>> ${isEmpty}'),
                                    ],
                                  ),
                                ));
                              }
                            },
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 16,
                                      bottom: 16,
                                      right: 8,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent.shade100,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Reset",
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    final result = await viewModel.resetDB();
                                    setState(() {
                                      isEmpty = result;
                                    });
                                  },
                                ),
                              ),
                              if (!isEmpty)
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        right: 16,
                                        bottom: 16,
                                        left: 8,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.cyanAccent.shade100,
                                        borderRadius: BorderRadius.circular(
                                          16,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Home",
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      Get.off(() => const LanguagePage());
                                    },
                                  ),
                                ),
                            ],
                          )
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Stack(
                              children: [
                                Container(
                                  width: Get.width,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.shade100,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width *
                                      viewModel.indicatorAmount.value,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.shade400,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'We are processing your data.....',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      );
              },
            );
          } else {
            return Container(
              child: Text("Something went wrong"),
            );
          }
        },
      ),
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
        margin: const EdgeInsets.all(16),
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
            const Text('Browse to import \nWith type of json.')
          ],
        ),
      ),
    );
  }
}
