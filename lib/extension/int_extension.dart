import 'package:flutter/widgets.dart';

extension IntExtension on int {
  double asSp(BuildContext context) => MediaQuery.of(context).textScaleFactor * this;

  DateTime parseAsDTODateTime({required bool isUtc}) => DateTime.fromMillisecondsSinceEpoch(this, isUtc: isUtc);
}
