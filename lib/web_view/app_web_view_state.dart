import 'package:freezed_annotation/freezed_annotation.dart';

import '../state_status.dart';

part 'app_web_view_state.freezed.dart';

@Freezed()
class AppWebViewState with _$AppWebViewState {
  const factory AppWebViewState({
    final int? progress,
    final String? pageStarted,
    final String? pageFinished,
    final String? currentUrl,
    @Default(false) final bool canGoBack,
    @Default(false) final bool canGoForward,
    @Default(StateStatus.initial) final StateStatus stateStatus,
  }) = _AppWebViewState;
}
