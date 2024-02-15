import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: Text(
          "Import File",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<ImportViewModel>(
        init: viewModel,
        builder: (vm) {
          return vm.isSyncData.isFalse
              ? Container(
                  child: vm.isDataEmpty.isTrue
                      ? GestureDetector(
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
                        )
                      : Text("data exist"),
                )
              : const _SyncDataView();
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
  const _SyncDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImportViewModel>(
      builder: (vm) {
        print(vm.indicatorAmount.value);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              LinearProgressIndicator(
                value: vm.indicatorAmount.value,
                semanticsLabel: 'Linear progress indicator',
              ),
              Text(
                'Linear progress indicator with a fixed color',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
