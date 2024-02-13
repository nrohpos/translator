// enum HeaderType {
//   ANDROID_KEY,
//   IOS_KEY,
//   NEW_KEY,
//   ENGLISH,
//   KHMER,
//   NEW_VALUE;
//
//   // static List<HeaderType> getAll() {
//   //   return [
//   //     HeaderType.ANDROID_KEY,
//   //     HeaderType.IOS_KEY,
//   //     HeaderType.NEW_KEY,
//   //     HeaderType.ENGLISH,
//   //     HeaderType.KHMER,
//   //     HeaderType.NEW_VALUE
//   //   ];
//   // }
//
//   String getName() {
//     switch (this) {
//       case HeaderType.ANDROID_KEY:
//         return "Android Key";
//       case HeaderType.IOS_KEY:
//         return "IOS Key";
//       case HeaderType.NEW_KEY:
//         return "New Key";
//       case HeaderType.ENGLISH:
//         return "English";
//       case HeaderType.KHMER:
//         return "Khmer";
//       case HeaderType.NEW_VALUE:
//         return "New value";
//     }
//   }
// }
enum HeaderType {
  KEY,
  VALUE;

  String getName() {
    switch (this) {
      case HeaderType.KEY:
        return "Key";
      case HeaderType.VALUE:
        return "Value";
    }
  }
}
