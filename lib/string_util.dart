import 'dart:math';

import 'package:flutter/widgets.dart';

String getHexCode(Characters characters, [String divider = " "]) {
  return characters
      .toList()
      .map((e) => e.codeUnits
          .map((e) => "\\u${e.toRadixString(16).toUpperCase()}")
          .join())
      .join(divider);
}

String randomString(int len) {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

String randomStringIncludeSpecialCharacters(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
