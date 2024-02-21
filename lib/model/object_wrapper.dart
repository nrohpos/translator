import 'language/language.dart';

class ObjectWrapper {
  static T fromMap<T>(Map<String, dynamic> map) {
    if (T is Language) {
      return Language.fromMap(map) as T;
    }
    // Add more type checks as needed

    throw ArgumentError("Type $T is not supported for conversion");
  }
}