import 'package:translator/model/keyword/keyword.dart';

import 'language/language.dart';

class ObjectWrapper {
  static T fromMap<T>(Map<String, dynamic> map) {
    if (T == Language) {
      return Language.fromMap(map) as T;
    } else if (T == KeyWord) {
      return KeyWord.fromMap(map) as T;
    }
    throw ArgumentError("Type $T is not supported for conversion");
  }
}
