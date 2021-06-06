import 'package:test/test.dart';
import 'package:typesense/src/exceptions/exceptions.dart';

void main() {
  test('ImportError', () {
    final exception = ImportError('import failed');
    expect(exception, isA<TypesenseException>());
    expect(exception.message, equals('import failed'));
  });
  test('MissingConfiguration', () {
    final exception = MissingConfiguration('configuration missing');
    expect(exception, isA<TypesenseException>());
    expect(exception.message, equals('configuration missing'));
  });
  group('RequestException:', () {
    RequestException exception;

    test('HttpError', () {
      exception = HttpError('http error', 0);
      expect(exception, isA<TypesenseException>());
      expect(exception, isA<RequestException>());
      expect(exception.message, equals('http error'));
      expect(exception.statusCode, equals(0));
    });
    test('ObjectAlreadyExists', () {
      exception = ObjectAlreadyExists('already exists');
      expect(exception, isA<TypesenseException>());
      expect(exception, isA<RequestException>());
      expect(exception.message, equals('already exists'));
      expect(exception.statusCode, equals(409));
    });
    test('ObjectNotFound', () {
      exception = ObjectNotFound('not found');
      expect(exception, isA<TypesenseException>());
      expect(exception, isA<RequestException>());
      expect(exception.message, equals('not found'));
      expect(exception.statusCode, equals(404));
    });
    test('ObjectUnprocessable', () {
      exception = ObjectUnprocessable('unprocessable');
      expect(exception, isA<TypesenseException>());
      expect(exception, isA<RequestException>());
      expect(exception.message, equals('unprocessable'));
      expect(exception.statusCode, equals(422));
    });
    test('RequestMalformed', () {
      exception = RequestMalformed('bad request');
      expect(exception, isA<TypesenseException>());
      expect(exception, isA<RequestException>());
      expect(exception.message, equals('bad request'));
      expect(exception.statusCode, equals(400));
    });
    test('RequestUnauthorized', () {
      exception = RequestUnauthorized('not allowed');
      expect(exception, isA<TypesenseException>());
      expect(exception, isA<RequestException>());
      expect(exception.message, equals('not allowed'));
      expect(exception.statusCode, equals(401));
    });
    test('ServerError', () {
      exception = ServerError('internal error', 500);
      expect(exception, isA<TypesenseException>());
      expect(exception, isA<RequestException>());
      expect(exception.message, equals('internal error'));
      expect(exception.statusCode, equals(500));
    });
  });
}
