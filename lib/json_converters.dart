import 'package:json_annotation/json_annotation.dart';

import 'extension/date_time_extension.dart';
import 'extension/int_extension.dart';
import 'extension/string_extension.dart';

class DateTimeStringConverter implements JsonConverter<DateTime, String> {
  const DateTimeStringConverter();

  @override
  DateTime fromJson(String json) => json.parseAsDTODateTime();

  @override
  String toJson(DateTime object) => object.formatToDTOString();
}

class DateTimeStringConverterNullable implements JsonConverter<DateTime?, String?> {
  const DateTimeStringConverterNullable();

  @override
  DateTime? fromJson(String? json) => json?.parseAsDTODateTime();

  @override
  String? toJson(DateTime? object) => object?.formatToDTOString();
}

class DateTimeEpochConverter implements JsonConverter<DateTime, int> {
  final bool isUtc;

  const DateTimeEpochConverter({required this.isUtc});

  @override
  DateTime fromJson(int json) => json.parseAsDTODateTime(isUtc: isUtc);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}

class DateTimeEpochConverterNullable implements JsonConverter<DateTime?, int?> {
  final bool isUtc;

  const DateTimeEpochConverterNullable({required this.isUtc});

  @override
  DateTime? fromJson(int? json) => json?.parseAsDTODateTime(isUtc: isUtc);

  @override
  int? toJson(DateTime? object) => object?.millisecondsSinceEpoch;
}

class BoolIntConverter implements JsonConverter<bool, int> {
  const BoolIntConverter();

  @override
  bool fromJson(int json) => json == 1;

  @override
  int toJson(bool object) => object ? 1 : 0;
}
