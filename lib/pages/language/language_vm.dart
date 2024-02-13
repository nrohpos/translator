import 'package:get/get.dart';
import 'package:translator/language/language.dart';

class LanguageViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<List<Language>> getLanguage() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    return Future(() => Language.values);
  }
}
