enum Language {
  KH,
  EN;

  String getName() {
    switch (this) {
      case KH:
        return "ខ្មែរ";
      case EN:
        return "English";
    }
  }
}
