import 'package:flutter/widgets.dart';

extension WidgetExtension on Widget {
  Widget paddingAll(double padding) => Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingHorizontal(double padding) => Padding(padding: EdgeInsets.symmetric(horizontal: padding), child: this);

  Widget paddingVertical(double padding) => Padding(padding: EdgeInsets.symmetric(vertical: padding), child: this);

  Widget paddingLeft(double padding) => Padding(padding: EdgeInsets.only(left: padding), child: this);

  Widget paddingTop(double padding) => Padding(padding: EdgeInsets.only(top: padding), child: this);

  Widget paddingRight(double padding) => Padding(padding: EdgeInsets.only(right: padding), child: this);

  Widget paddingBottom(double padding) => Padding(padding: EdgeInsets.only(bottom: padding), child: this);

  Widget marginAll(double margin) => Container(margin: EdgeInsets.all(margin), child: this);

  Widget marginHorizontal(double margin) => Container(margin: EdgeInsets.symmetric(horizontal: margin), child: this);

  Widget marginVertical(double margin) => Container(margin: EdgeInsets.symmetric(vertical: margin), child: this);

  Widget marginOnly({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0}) => Container(margin: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom), child: this);
}
