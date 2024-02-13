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

  String getFileName() {
    switch (this) {
      case Language.KH:
        return "localize_kh";
      case Language.EN:
        return "localize_en";
    }
  }
}
