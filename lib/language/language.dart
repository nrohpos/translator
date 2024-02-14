enum Language {
  kh,
  en;

  String getName() {
    switch (this) {
      case kh:
        return "ខ្មែរ";
      case en:
        return "English";
    }
  }

  String getFileName() {
    switch (this) {
      case Language.kh:
        return "localize_kh";
      case Language.en:
        return "localize_en";
    }
  }
}
