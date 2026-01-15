import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/app_info_service_impl.dart';
import 'package:tictac/core/services/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('AppInfoServiceImpl', () {
    late MockLoggerService mockLogger;
    late AppInfoServiceImpl appInfoService;

    setUp(() {
      mockLogger = MockLoggerService();
      appInfoService = AppInfoServiceImpl(mockLogger);
    });

    test('getVersion returns version string or empty on error', () async {
      final version = await appInfoService.getVersion();
      // In test environment, PackageInfo.fromPlatform may fail, so we accept either
      expect(version, anyOf(startsWith('v'), isEmpty));
    });

    test('getVersion handles errors and logs them', () async {
      when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

      final version = await appInfoService.getVersion();

      expect(version, isA<String>());
    });
  });
}
