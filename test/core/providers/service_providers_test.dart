import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/app_info_service.dart';
import 'package:tictac/core/services/logger_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Service Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('audioServiceProvider', () {});

    group('loggerServiceProvider', () {
      test('should provide LoggerService instance', () {
        final LoggerService loggerService = container.read(loggerServiceProvider);

        expect(loggerService, isA<LoggerService>());
        expect(loggerService, isNotNull);
      });

      test('should provide same instance on multiple reads', () {
        final LoggerService loggerService1 = container.read(loggerServiceProvider);
        final LoggerService loggerService2 = container.read(loggerServiceProvider);

        expect(loggerService1, same(loggerService2));
      });
    });

    group('appInfoServiceProvider', () {
      test('should provide AppInfoService instance', () {
        final AppInfoService appInfoService = container.read(appInfoServiceProvider);

        expect(appInfoService, isA<AppInfoService>());
        expect(appInfoService, isNotNull);
      });

      test('should provide same instance on multiple reads', () {
        final AppInfoService appInfoService1 = container.read(appInfoServiceProvider);
        final AppInfoService appInfoService2 = container.read(appInfoServiceProvider);

        expect(appInfoService1, same(appInfoService2));
      });
    });
  });
}
