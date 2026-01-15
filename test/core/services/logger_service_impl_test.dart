import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/services/logger_service_impl.dart';

void main() {
  group('LoggerServiceImpl', () {
    late LoggerServiceImpl loggerService;

    setUp(() {
      loggerService = LoggerServiceImpl();
    });

    test('error should not throw', () {
      expect(
        () => loggerService.error('Test error'),
        returnsNormally,
      );
      loggerService.error('Test error');
    });

    test('error with exception should not throw', () {
      expect(
        () => loggerService.error('Test error', Exception('Test'), StackTrace.current),
        returnsNormally,
      );
      loggerService.error('Test error', Exception('Test'), StackTrace.current);
    });

    test('warning should not throw', () {
      expect(() => loggerService.warning('Test warning'), returnsNormally);
    });

    test('info should not throw', () {
      expect(() => loggerService.info('Test info'), returnsNormally);
    });

    test('debug should not throw', () {
      expect(() => loggerService.debug('Test debug'), returnsNormally);
    });
  });
}


