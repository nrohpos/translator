import 'package:translator/extension/string+extension.dart';

class KeyWord {
  late String key;
  late String value;

  KeyWord.init({this.key = "", this.value = ""});

  factory KeyWord.fromMap(Map<String, dynamic> map) {
    return KeyWord.init(
      key: (map["key"] as String?).orEmpty,
      value: (map["value"] as String?).orEmpty,
    );
  }
}
