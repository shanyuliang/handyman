// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_web_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppWebViewState {
  int? get progress => throw _privateConstructorUsedError;
  String? get pageStarted => throw _privateConstructorUsedError;
  String? get pageFinished => throw _privateConstructorUsedError;
  String? get currentUrl => throw _privateConstructorUsedError;
  bool get canGoBack => throw _privateConstructorUsedError;
  bool get canGoForward => throw _privateConstructorUsedError;
  StateStatus get stateStatus => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppWebViewStateCopyWith<AppWebViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppWebViewStateCopyWith<$Res> {
  factory $AppWebViewStateCopyWith(
          AppWebViewState value, $Res Function(AppWebViewState) then) =
      _$AppWebViewStateCopyWithImpl<$Res, AppWebViewState>;
  @useResult
  $Res call(
      {int? progress,
      String? pageStarted,
      String? pageFinished,
      String? currentUrl,
      bool canGoBack,
      bool canGoForward,
      StateStatus stateStatus});
}

/// @nodoc
class _$AppWebViewStateCopyWithImpl<$Res, $Val extends AppWebViewState>
    implements $AppWebViewStateCopyWith<$Res> {
  _$AppWebViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = freezed,
    Object? pageStarted = freezed,
    Object? pageFinished = freezed,
    Object? currentUrl = freezed,
    Object? canGoBack = null,
    Object? canGoForward = null,
    Object? stateStatus = null,
  }) {
    return _then(_value.copyWith(
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int?,
      pageStarted: freezed == pageStarted
          ? _value.pageStarted
          : pageStarted // ignore: cast_nullable_to_non_nullable
              as String?,
      pageFinished: freezed == pageFinished
          ? _value.pageFinished
          : pageFinished // ignore: cast_nullable_to_non_nullable
              as String?,
      currentUrl: freezed == currentUrl
          ? _value.currentUrl
          : currentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      canGoBack: null == canGoBack
          ? _value.canGoBack
          : canGoBack // ignore: cast_nullable_to_non_nullable
              as bool,
      canGoForward: null == canGoForward
          ? _value.canGoForward
          : canGoForward // ignore: cast_nullable_to_non_nullable
              as bool,
      stateStatus: null == stateStatus
          ? _value.stateStatus
          : stateStatus // ignore: cast_nullable_to_non_nullable
              as StateStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppWebViewStateCopyWith<$Res>
    implements $AppWebViewStateCopyWith<$Res> {
  factory _$$_AppWebViewStateCopyWith(
          _$_AppWebViewState value, $Res Function(_$_AppWebViewState) then) =
      __$$_AppWebViewStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? progress,
      String? pageStarted,
      String? pageFinished,
      String? currentUrl,
      bool canGoBack,
      bool canGoForward,
      StateStatus stateStatus});
}

/// @nodoc
class __$$_AppWebViewStateCopyWithImpl<$Res>
    extends _$AppWebViewStateCopyWithImpl<$Res, _$_AppWebViewState>
    implements _$$_AppWebViewStateCopyWith<$Res> {
  __$$_AppWebViewStateCopyWithImpl(
      _$_AppWebViewState _value, $Res Function(_$_AppWebViewState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = freezed,
    Object? pageStarted = freezed,
    Object? pageFinished = freezed,
    Object? currentUrl = freezed,
    Object? canGoBack = null,
    Object? canGoForward = null,
    Object? stateStatus = null,
  }) {
    return _then(_$_AppWebViewState(
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int?,
      pageStarted: freezed == pageStarted
          ? _value.pageStarted
          : pageStarted // ignore: cast_nullable_to_non_nullable
              as String?,
      pageFinished: freezed == pageFinished
          ? _value.pageFinished
          : pageFinished // ignore: cast_nullable_to_non_nullable
              as String?,
      currentUrl: freezed == currentUrl
          ? _value.currentUrl
          : currentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      canGoBack: null == canGoBack
          ? _value.canGoBack
          : canGoBack // ignore: cast_nullable_to_non_nullable
              as bool,
      canGoForward: null == canGoForward
          ? _value.canGoForward
          : canGoForward // ignore: cast_nullable_to_non_nullable
              as bool,
      stateStatus: null == stateStatus
          ? _value.stateStatus
          : stateStatus // ignore: cast_nullable_to_non_nullable
              as StateStatus,
    ));
  }
}

/// @nodoc

class _$_AppWebViewState implements _AppWebViewState {
  const _$_AppWebViewState(
      {this.progress,
      this.pageStarted,
      this.pageFinished,
      this.currentUrl,
      this.canGoBack = false,
      this.canGoForward = false,
      this.stateStatus = StateStatus.initial});

  @override
  final int? progress;
  @override
  final String? pageStarted;
  @override
  final String? pageFinished;
  @override
  final String? currentUrl;
  @override
  @JsonKey()
  final bool canGoBack;
  @override
  @JsonKey()
  final bool canGoForward;
  @override
  @JsonKey()
  final StateStatus stateStatus;

  @override
  String toString() {
    return 'AppWebViewState(progress: $progress, pageStarted: $pageStarted, pageFinished: $pageFinished, currentUrl: $currentUrl, canGoBack: $canGoBack, canGoForward: $canGoForward, stateStatus: $stateStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppWebViewState &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.pageStarted, pageStarted) ||
                other.pageStarted == pageStarted) &&
            (identical(other.pageFinished, pageFinished) ||
                other.pageFinished == pageFinished) &&
            (identical(other.currentUrl, currentUrl) ||
                other.currentUrl == currentUrl) &&
            (identical(other.canGoBack, canGoBack) ||
                other.canGoBack == canGoBack) &&
            (identical(other.canGoForward, canGoForward) ||
                other.canGoForward == canGoForward) &&
            (identical(other.stateStatus, stateStatus) ||
                other.stateStatus == stateStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress, pageStarted,
      pageFinished, currentUrl, canGoBack, canGoForward, stateStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppWebViewStateCopyWith<_$_AppWebViewState> get copyWith =>
      __$$_AppWebViewStateCopyWithImpl<_$_AppWebViewState>(this, _$identity);
}

abstract class _AppWebViewState implements AppWebViewState {
  const factory _AppWebViewState(
      {final int? progress,
      final String? pageStarted,
      final String? pageFinished,
      final String? currentUrl,
      final bool canGoBack,
      final bool canGoForward,
      final StateStatus stateStatus}) = _$_AppWebViewState;

  @override
  int? get progress;
  @override
  String? get pageStarted;
  @override
  String? get pageFinished;
  @override
  String? get currentUrl;
  @override
  bool get canGoBack;
  @override
  bool get canGoForward;
  @override
  StateStatus get stateStatus;
  @override
  @JsonKey(ignore: true)
  _$$_AppWebViewStateCopyWith<_$_AppWebViewState> get copyWith =>
      throw _privateConstructorUsedError;
}
