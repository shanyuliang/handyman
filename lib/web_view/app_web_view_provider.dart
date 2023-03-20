import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_web_view_notifier.dart';
import 'app_web_view_state.dart';

final appWebViewProvider =
    StateNotifierProvider.autoDispose.family<AppWebViewNotifier, AppWebViewState, String?>((ref, initialUrl) {
  return AppWebViewNotifier(initialUrl: initialUrl);
});
