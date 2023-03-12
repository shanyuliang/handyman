/// This class can be used as a general return type that carrying data,
/// exception and message.
abstract class Result<T> {
  factory Result.success({T? data}) => Success<T>._(data);

  factory Result.failure({T? data, Exception? exception, String? message}) =>
      Failure<T>._(data, exception, message);

  factory Result.cancelled({T? data, String? message}) =>
      Cancelled<T>._(data, message);

  Result._();

  T get data;

  T? get dataOrNull;

  Exception? get exceptionOrNull;

  String? get messageOrNull;

  void use({
    void Function(Success<T> success)? whenSuccess,
    void Function(Failure<T> failure)? whenFailure,
    void Function(Cancelled<T> cancelled)? whenCancelled,
    void Function(Result<T> result)? whenElse,
  }) {
    if (this is Success) {
      (whenSuccess ?? whenElse)?.call(this as Success<T>);
    } else if (this is Failure) {
      (whenFailure ?? whenElse)?.call(this as Failure<T>);
    } else {
      (whenCancelled ?? whenElse)?.call(this as Cancelled<T>);
    }
  }

  R transform<R>({
    R Function(Success<T> success)? whenSuccess,
    R Function(Failure<T> failure)? whenFailure,
    R Function(Cancelled<T> cancelled)? whenCancelled,
    required R Function(Result<T> result) whenElse,
  }) {
    if (this is Success) {
      return (whenSuccess ?? whenElse).call(this as Success<T>);
    } else if (this is Failure) {
      return (whenFailure ?? whenElse).call(this as Failure<T>);
    } else {
      return (whenCancelled ?? whenElse).call(this as Cancelled<T>);
    }
  }

  R? transformNullable<R>({
    R Function(Success<T> success)? whenSuccess,
    R Function(Failure<T> failure)? whenFailure,
    R Function(Cancelled<T> cancelled)? whenCancelled,
    R Function(Result<T> result)? whenElse,
  }) {
    if (this is Success) {
      return (whenSuccess ?? whenElse)?.call(this as Success<T>);
    } else if (this is Failure) {
      return (whenFailure ?? whenElse)?.call(this as Failure<T>);
    } else {
      return (whenCancelled ?? whenElse)?.call(this as Cancelled<T>);
    }
  }
}

class Success<T> extends Result<T> {
  Success._(this._data) : super._();
  final T? _data;

  @override
  String toString() => "{Success={data=$_data}}";

  @override
  T get data => _data!;

  @override
  T? get dataOrNull => _data;

  @override
  Exception? get exceptionOrNull => null;

  @override
  String? get messageOrNull => null;
}

class Failure<T> extends Result<T> {
  Failure._(this._data, this._exception, this._message) : super._();
  final T? _data;
  final Exception? _exception;
  final String? _message;

  @override
  String toString() =>
      "{Failure={data=$_data,exception=$_exception,message=$_message}}";

  @override
  T get data => _data!;

  @override
  T? get dataOrNull => _data;

  @override
  Exception? get exceptionOrNull => _exception;

  @override
  String? get messageOrNull => _message ?? _exception?.toString();
}

class Cancelled<T> extends Result<T> {
  Cancelled._(this._data, this._message) : super._();
  final T? _data;
  final String? _message;

  @override
  String toString() => "{Cancelled={data=$_data,message=$_message}}";

  @override
  T get data => _data!;

  @override
  T? get dataOrNull => _data;

  @override
  Exception? get exceptionOrNull => null;

  @override
  String? get messageOrNull => _message;
}
