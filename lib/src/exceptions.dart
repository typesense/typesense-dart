class MissingConfiguration implements Exception {
  final String message;
  MissingConfiguration(this.message);
}

class ObjectAlreadyExists implements Exception {}

class ObjectNotFound implements Exception {}

class ObjectUnprocessable implements Exception {}

class RequestMalformed implements Exception {}

class RequestUnauthorized implements Exception {}
