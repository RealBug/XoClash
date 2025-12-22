import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';
import 'package:tictac/features/user/domain/usecases/create_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void setUpAllFallbacks() {
  registerFallbackValue(
    const User(username: 'test-user'),
  );
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });

  late CreateUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = CreateUserUseCase(mockRepository);
  });

  group('CreateUserUseCase', () {
    test('should create user with trimmed username and email', () async {
      const String username = '  test-user  ';
      const String email = '  test@example.com  ';
      const String expectedUsername = 'test-user';
      const String expectedEmail = 'test@example.com';
      const String avatar = 'avatar-url';
      const User expectedUser = User(
        username: expectedUsername,
        email: expectedEmail,
        avatar: avatar,
      );

      when(() => mockRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(username, email: email, avatar: avatar);

      expect(result.username, equals(expectedUsername));
      expect(result.email, equals(expectedEmail));
      expect(result.avatar, equals(avatar));
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should create user without email and avatar', () async {
      const String username = 'test-user';
      const User expectedUser = User(username: username);

      when(() => mockRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(username);

      expect(result.username, equals(username));
      expect(result.email, isNull);
      expect(result.avatar, isNull);
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should handle null email correctly', () async {
      const String username = 'test-user';
      const User expectedUser = User(username: username);

      when(() => mockRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(username);

      expect(result.username, equals(username));
      expect(result.email, isNull);
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should trim empty email string', () async {
      const String username = 'test-user';
      const String email = '   ';
      const User expectedUser = User(username: username, email: '');

      when(() => mockRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(username, email: email);

      expect(result.username, equals(username));
      expect(result.email, equals(''));
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should propagate errors from repository', () async {
      const String username = 'test-user';

      when(() => mockRepository.saveUser(any()))
          .thenThrow(Exception('Repository error'));

      expect(() => useCase.execute(username), throwsException);
      verify(() => mockRepository.saveUser(any())).called(1);
    });
  });
}

