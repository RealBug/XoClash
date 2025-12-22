import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/app_info_service.dart';
import 'package:tictac/features/settings/domain/usecases/get_app_version_usecase.dart';

class MockAppInfoService extends Mock implements AppInfoService {}

void main() {
  late GetAppVersionUseCase useCase;
  late MockAppInfoService mockAppInfoService;

  setUp(() {
    mockAppInfoService = MockAppInfoService();
    useCase = GetAppVersionUseCase(mockAppInfoService);
  });

  group('GetAppVersionUseCase', () {
    test('should return version from app info service', () async {
      const String expectedVersion = 'v1.2.3';

      when(() => mockAppInfoService.getVersion()).thenAnswer((_) async => expectedVersion);

      final String result = await useCase.execute();

      expect(result, equals(expectedVersion));
      verify(() => mockAppInfoService.getVersion()).called(1);
    });

    test('should return empty string when service returns empty string', () async {
      when(() => mockAppInfoService.getVersion()).thenAnswer((_) async => '');

      final String result = await useCase.execute();

      expect(result, isEmpty);
      verify(() => mockAppInfoService.getVersion()).called(1);
    });

    test('should propagate errors from app info service', () async {
      when(() => mockAppInfoService.getVersion()).thenThrow(Exception('Error getting version'));

      expect(() => useCase.execute(), throwsException);
      verify(() => mockAppInfoService.getVersion()).called(1);
    });
  });
}
