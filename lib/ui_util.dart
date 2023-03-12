import 'package:flutter/widgets.dart';

import 'debug_util.dart';

class UIUtil {
  UIUtil._();

  static final UIUtil _instance = UIUtil._();

  factory UIUtil() => _instance;

  Size getSize(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;
    debugUtil.log("Size of $key: $size");
    return size;
  }

  Offset getOffset(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    debugUtil.log("Offset of $key: $offset");
    return offset;
  }
}

UIUtil uiUtil = UIUtil();
