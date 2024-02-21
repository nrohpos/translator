extension OptionalString on String? {
  String get orEmpty => this == null ? "" : this!;
}
