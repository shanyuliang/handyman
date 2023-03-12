class CancellationException implements Exception {
  @pragma("vm:entry-point")
  const CancellationException([this.message = 'Cancelled']);

  final String message;

  @override
  String toString() => "Exception: $message";
}
