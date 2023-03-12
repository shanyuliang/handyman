import 'package:flutter/material.dart';

extension StringExtension on String {
  static final whitespacesRegExp = RegExp(r"\s+");

  String asNameGetInitials({int? maxResultLength}) {
    final nameParts = trim().split(whitespacesRegExp);
    final initials = nameParts.fold(
        '',
        (previousValue, element) =>
            '$previousValue${element.isNotEmpty ? element[0] : ''}');
    if (initials.length > (maxResultLength ?? 3)) {
      return initials.substring(0, maxResultLength).toUpperCase();
    } else {
      return initials.toUpperCase();
    }
  }

  Color mapToPrimaryColor() {
    final colorIndex = hashCode % Colors.primaries.length;
    return Colors.primaries[colorIndex];
  }

  Color mapToHSLColor(double saturation, double lightness) {
    double hue = (hashCode % 360).toDouble();
    HSLColor hslColor = HSLColor.fromAHSL(1.0, hue, saturation, lightness);
    return hslColor.toColor();
  }

  DateTime parseAsDTODateTime() => DateTime.parse(this);

  String superTrim() => trim().replaceAll(whitespacesRegExp, ' ');

  String interpolate(List<String> params) {
    String result = this;
    for (int i = 0; i < params.length; i++) {
      result = result.replaceAll('%${i + 1}\$s', params[i]);
    }
    return result;
  }

  String capitalizeEachWord() {
    if (length <= 1) {
      return toUpperCase();
    }
    final words = split(' ');
    final capitalized = words.map((final word) {
      final first = word.substring(0, 1).toUpperCase();
      final rest = word.substring(1);

      return '$first$rest';
    });

    return capitalized.join(' ');
  }
}

extension StringNullableExtension on String? {
  bool isNullOrEmpty() {
    final self = this;
    if (self == null) {
      return true;
    } else {
      return self.isEmpty;
    }
  }
}
