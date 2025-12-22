import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';
import 'package:tictac/features/user/domain/usecases/delete_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/get_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/has_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
  });

  setUpAll(() {
    registerFallbackValue(const User(username: 'test'));
  });

  group('GetUserUseCase - Advanced', () {
    late GetUserUseCase useCase;

    setUp(() {
      useCase = GetUserUseCase(mockRepository);
    });

    test('should return user when exists', () async {
      const User user = User(username: 'testuser', email: 'test@example.com');
      when(() => mockRepository.getUser()).thenAnswer((_) async => user);

      final User? result = await useCase.execute();

      expect(result, equals(user));
      verify(() => mockRepository.getUser()).called(1);
    });

    test('should return null when no user exists', () async {
      when(() => mockRepository.getUser()).thenAnswer((_) async => null);

      final User? result = await useCase.execute();

      expect(result, isNull);
      verify(() => mockRepository.getUser()).called(1);
    });

    test('should handle repository errors', () async {
      when(() => mockRepository.getUser())
          .thenThrow(Exception('Database error'));

      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
    });

    test('should return user with avatar', () async {
      const User user = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: 'avatar_1',
      );
      when(() => mockRepository.getUser()).thenAnswer((_) async => user);

      final User? result = await useCase.execute();

      expect(result?.avatar, equals('avatar_1'));
    });

    test('should handle user with minimum fields', () async {
      const User user = User(username: 'user');
      when(() => mockRepository.getUser()).thenAnswer((_) async => user);

      final User? result = await useCase.execute();

      expect(result, isNotNull);
      expect(result!.username, equals('user'));
      expect(result.email, isNull);
      expect(result.avatar, isNull);
    });

    test('should handle multiple consecutive calls', () async {
      const User user = User(username: 'testuser');
      when(() => mockRepository.getUser()).thenAnswer((_) async => user);

      final User? result1 = await useCase.execute();
      final User? result2 = await useCase.execute();
      final User? result3 = await useCase.execute();

      expect(result1, equals(user));
      expect(result2, equals(user));
      expect(result3, equals(user));
      verify(() => mockRepository.getUser()).called(3);
    });

    test('should handle timeout in repository call', () async {
      when(() => mockRepository.getUser()).thenAnswer(
        (_) => Future<User>.delayed(
          const Duration(seconds: 10),
          () => const User(username: 'test'),
        ),
      );

      final Future<User?> future = useCase.execute().timeout(
            const Duration(milliseconds: 100),
            onTimeout: () => null,
          );

      final User? result = await future;
      expect(result, isNull);
    });
  });


  group('HasUserUseCase - Advanced', () {
    late HasUserUseCase useCase;

    setUp(() {
      useCase = HasUserUseCase(mockRepository);
    });

    test('should return true when user exists', () async {
      when(() => mockRepository.hasUser()).thenAnswer((_) async => true);

      final bool result = await useCase.execute();

      expect(result, isTrue);
      verify(() => mockRepository.hasUser()).called(1);
    });

    test('should return false when no user exists', () async {
      when(() => mockRepository.hasUser()).thenAnswer((_) async => false);

      final bool result = await useCase.execute();

      expect(result, isFalse);
      verify(() => mockRepository.hasUser()).called(1);
    });

    test('should handle errors', () async {
      when(() => mockRepository.hasUser()).thenThrow(Exception('Check failed'));

      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
    });

    test('should be idempotent', () async {
      when(() => mockRepository.hasUser()).thenAnswer((_) async => true);

      final bool result1 = await useCase.execute();
      final bool result2 = await useCase.execute();
      final bool result3 = await useCase.execute();

      expect(result1, isTrue);
      expect(result2, isTrue);
      expect(result3, isTrue);
      verify(() => mockRepository.hasUser()).called(3);
    });

    test('should handle rapid consecutive checks', () async {
      when(() => mockRepository.hasUser()).thenAnswer((_) async => true);

      final List<Future<bool>> futures = List<Future<bool>>.generate(10, (int _) => useCase.execute());
      final List<bool> results = await Future.wait(futures);

      expect(results.every((bool r) => r == true), isTrue);
      verify(() => mockRepository.hasUser()).called(10);
    });
  });

  group('DeleteUserUseCase - Advanced', () {
    late DeleteUserUseCase useCase;

    setUp(() {
      useCase = DeleteUserUseCase(mockRepository);
    });

    test('should delete user successfully', () async {
      when(() => mockRepository.deleteUser()).thenAnswer((_) async {});

      await useCase.execute();

      verify(() => mockRepository.deleteUser()).called(1);
    });

    test('should handle delete errors', () async {
      when(() => mockRepository.deleteUser())
          .thenThrow(Exception('Delete failed'));

      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
    });

    test('should not throw when deleting non-existent user', () async {
      when(() => mockRepository.deleteUser()).thenAnswer((_) async {});

      await useCase.execute();

      verify(() => mockRepository.deleteUser()).called(1);
    });

    test('should be idempotent', () async {
      when(() => mockRepository.deleteUser()).thenAnswer((_) async {});

      await useCase.execute();
      await useCase.execute();

      verify(() => mockRepository.deleteUser()).called(2);
    });

    test('should handle concurrent delete attempts', () async {
      when(() => mockRepository.deleteUser()).thenAnswer((_) async {});

      final List<Future<void>> futures = <Future<void>>[
        useCase.execute(),
        useCase.execute(),
        useCase.execute(),
      ];

      await Future.wait(futures);

      verify(() => mockRepository.deleteUser()).called(3);
    });
  });


  group('Use Cases - Edge Cases', () {
    test('should handle null repository responses gracefully', () async {
      final GetUserUseCase getUserUseCase = GetUserUseCase(mockRepository);

      when(() => mockRepository.getUser()).thenAnswer((_) async => null);

      final User? result = await getUserUseCase.execute();
      expect(result, isNull);
    });

  });
}
