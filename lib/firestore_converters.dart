import 'package:cloud_firestore/cloud_firestore.dart';

DateTime dateTimeFromTimestamp(Timestamp timestamp) {
  return timestamp.toDate();
}

Timestamp dateTimeToTimestamp(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}

DateTime? dateTimeFromTimestampNullable(Timestamp? timestamp) {
  return timestamp?.toDate();
}

Timestamp? dateTimeToTimestampNullable(DateTime? dateTime) {
  if (dateTime != null) {
    return Timestamp.fromDate(dateTime);
  } else {
    return null;
  }
}

dynamic timestampSerializer(dynamic object) {
  if (object is Timestamp) {
    return object.toDate().toIso8601String();
  }
  return object;
}
