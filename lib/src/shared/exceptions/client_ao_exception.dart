class ClientAoException implements Exception {
  final String message;
  final String? statusCode;
  final StackTrace? stackTrace;
  final int? requestId;
  final String? collectionId;

  ClientAoException({
    required this.message,
    this.statusCode,
    this.requestId,
    this.collectionId,
    this.stackTrace,
  });
}
