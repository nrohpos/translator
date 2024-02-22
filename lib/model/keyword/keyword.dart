import 'package:translator/extension/string+extension.dart';

class KeyWord {
  late String id;
  late String key;
  late String value;

  KeyWord.init({this.key = "", this.value = "", this.id = ""});

  factory KeyWord.fromMap(Map<String, dynamic> map) {
    return KeyWord.init(
      key: (map["key"] as String?).orEmpty,
      value: (map["value"] as String?).orEmpty,
      id: (map["id"] as String?).orEmpty,
    );
  }

  dynamic toJson() => {
        'key': key,
        'value': value,
        'id': id,
      };

  dynamic export() => {
        'key': key,
        'value': value,
      };
}
