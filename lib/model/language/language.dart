class Language {
  String? name;

  Language.init({this.name});

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language.init(name: map["locale"] as String?);
  }
}
