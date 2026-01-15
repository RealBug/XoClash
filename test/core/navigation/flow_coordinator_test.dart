import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/navigation/coordinator.dart';
import 'package:tictac/core/navigation/flow_coordinator.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/core/services/navigation_service.dart';

class MockCoordinator extends Mock implements Coordinator {}
class MockLoggerService extends Mock implements LoggerService {}
class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockCoordinator mockCoordinator1;
  late MockCoordinator mockCoordinator2;
  late FlowCoordinator flowCoordinator;
  late MockNavigationService mockNavigation;

  setUp(() {
    mockCoordinator1 = MockCoordinator();
    mockCoordinator2 = MockCoordinator();
    mockNavigation = MockNavigationService();
    flowCoordinator = FlowCoordinator.withCoordinators([
      mockCoordinator1,
      mockCoordinator2,
    ]);
  });

  group('handle', () {
    test('dispatches to first coordinator that can handle the event', () {
      final event = RequestLogin();
      when(() => mockCoordinator1.canHandle(event)).thenReturn(false);
      when(() => mockCoordinator2.canHandle(event)).thenReturn(true);

      flowCoordinator.handle(event);

      verify(() => mockCoordinator1.canHandle(event)).called(1);
      verify(() => mockCoordinator2.canHandle(event)).called(1);
      verify(() => mockCoordinator2.handle(event)).called(1);
      verifyNever(() => mockCoordinator1.handle(event));
    });

    test('stops checking after first handler found', () {
      final event = RequestNewGame();
      when(() => mockCoordinator1.canHandle(event)).thenReturn(true);

      flowCoordinator.handle(event);

      verify(() => mockCoordinator1.canHandle(event)).called(1);
      verify(() => mockCoordinator1.handle(event)).called(1);
      verifyNever(() => mockCoordinator2.canHandle(event));
    });

    test('does nothing if no coordinator can handle', () {
      final event = RequestStatistics();
      when(() => mockCoordinator1.canHandle(event)).thenReturn(false);
      when(() => mockCoordinator2.canHandle(event)).thenReturn(false);

      flowCoordinator.handle(event);

      verifyNever(() => mockCoordinator1.handle(event));
      verifyNever(() => mockCoordinator2.handle(event));
    });

    test('logs warning when event is not handled and logger is provided', () {
      final logger = MockLoggerService();
      final flowCoordinatorWithLogger = FlowCoordinator.withCoordinators(
        [mockCoordinator1, mockCoordinator2],
        logger: logger,
      );
      final event = RequestStatistics();
      when(() => mockCoordinator1.canHandle(event)).thenReturn(false);
      when(() => mockCoordinator2.canHandle(event)).thenReturn(false);

      flowCoordinatorWithLogger.handle(event);

      verify(() => logger.warning('Unhandled FlowEvent: ${event.runtimeType}'))
          .called(1);
    });
  });

  group('constructor', () {
    test('creates FlowCoordinator with all coordinators', () {
      final coordinator = FlowCoordinator(mockNavigation);
      expect(coordinator, isA<FlowCoordinator>());
    });

    test('creates FlowCoordinator with logger', () {
      final logger = MockLoggerService();
      final coordinator = FlowCoordinator(mockNavigation, logger: logger);
      expect(coordinator, isA<FlowCoordinator>());
    });
  });
}
