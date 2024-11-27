class NetworkResult<T> {
  late final T? _data;
  late final Exception? _exception;

  late final bool _success;

  NetworkResult.success([T? data]) {
    _data = data;
    _exception = null;
    _success = true;
  }

  NetworkResult.wrongStatusCode(int status) {
    _exception = Exception('Response had wrong status-code ($status)');
    _data = null;
    _success = false;
  }

  NetworkResult.exception(Exception exception) {
    _exception = exception;
    _data = null;
    _success = false;
  }

  bool get isSuccessful => _success;
  bool get isNotSuccessful => !_success;

  T get data {
    if (!_success) throw StateError('Tried to access data from an unsuccessful NetworkResult');
    if (_data == null) throw StateError('Tried to access data from NetworkResult that was not initialized with data');
    return _data!;
  }

  String get errorMessage {
    if (_success) throw StateError('Tried to access exception data from a successful NetworkResult');
    final exception = _exception!.toString();

    // remove default formatting
    if (exception.startsWith('Exception: ')) {
      return exception.substring(11);
    }

    return exception;
  }
}
