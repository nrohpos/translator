import 'package:get/get.dart';
import 'package:translator/language/language.dart';

class LanguageViewModel extends GetxController {
  Future<List<Language>> getLanguage() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return Future(() => Language.values);
  }
}
