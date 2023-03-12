import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';

class DebugUtil {
  late DateFormat _debugDateFormat;
  late DateTime _durationStart;

  DebugUtil._() {
    if (!kReleaseMode) {
      _debugDateFormat = DateFormat("HH:mm:ss.SSSSSS");
      _durationStart = DateTime.now();
    }
  }

  static final DebugUtil _instance = DebugUtil._();

  factory DebugUtil() => _instance;

  mark([String? tag]) {
    if (!kReleaseMode) {
      debugPrint(
          "[${Trace.current(1).frames[0].member}]${tag != null ? " $tag" : ""}");
    }
  }

  markWithTime() {
    if (!kReleaseMode) {
      DateTime now = DateTime.now();
      debugPrint(
          "[${Trace.current(1).frames[0].member}] [${_debugDateFormat.format(now)}]");
    }
  }

  markDurationStart() {
    if (!kReleaseMode) {
      _durationStart = DateTime.now();
      debugPrint(
          "[${Trace.current(1).frames[0].member}] [${_debugDateFormat.format(_durationStart)}]");
    }
  }

  markWithDuration() {
    if (!kReleaseMode) {
      DateTime now = DateTime.now();
      Duration duration = now.difference(_durationStart);
      debugPrint(
          "[${Trace.current(1).frames[0].member}] [${_debugDateFormat.format(now)}] [${duration.toString()}]");
    }
  }

  log(String message, [String? tag]) {
    if (!kReleaseMode) {
      debugPrint(
          "[${Trace.current(1).frames[0].member}]${tag != null ? " $tag" : ""} $message");
    }
  }

  logWithTime(String message) {
    if (!kReleaseMode) {
      DateTime now = DateTime.now();
      debugPrint(
          "[${Trace.current(1).frames[0].member}] [${_debugDateFormat.format(now)}] $message");
    }
  }

  logWithDuration(String message) {
    if (!kReleaseMode) {
      DateTime now = DateTime.now();
      Duration duration = now.difference(_durationStart);
      debugPrint(
          "[${Trace.current(1).frames[0].member}] [${_debugDateFormat.format(now)}] [${duration.toString()}] $message");
    }
  }
}

DebugUtil debugUtil = DebugUtil();
