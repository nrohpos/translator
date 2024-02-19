import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/pages/home/language_page.dart';
import 'package:translator/pages/import/import_error_type.dart';
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
      body: GetBuilder<ImportViewModel>(
        init: viewModel,
        builder: (vm) {
          // if (vm.isDataEmpty.isFalse) {
          //   Get.offAllNamed("/language");
          // }
          return FutureBuilder(
              future: vm.checkData(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapShot.connectionState == ConnectionState.done) {
                  print("asdfjskdfsdf ${snapShot.data}");
                  if (!(snapShot.data ?? true)) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const LanguagePage()));
                  }
                }
                return vm.isSyncData.isFalse
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
                                final type = await vm.getData(language);
                                if (type == ImportErrorType.success) {
                                  // Since screen
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Wrong format, Make sure it is a json file!'),
                                  ));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Please enter a language'),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent.shade100,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Reset",
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    await vm.resetDB();
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : _SyncDataView(
                        percentage: vm.indicatorAmount.value,
                      );
              });
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

class _SyncDataView extends StatelessWidget {
  final double percentage;

  const _SyncDataView({super.key, this.percentage = 0});

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Stack(
            children: [
              Container(
                width: width,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.cyan.shade100,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ),
              Container(
                width: width * percentage,
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
  }
}
