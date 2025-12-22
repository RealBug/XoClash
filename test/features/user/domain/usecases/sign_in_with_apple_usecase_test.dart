import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/auth/data/datasources/auth_datasource.dart';
import 'package:tictac/features/auth/data/services/auth_backend_service.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';
import 'package:tictac/features/user/domain/usecases/sign_in_with_apple_usecase.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockUserRepository extends Mock implements UserRepository {}

void setUpAllFallbacks() {
  registerFallbackValue(const User(username: 'fallback'));
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });
  late MockAuthDataSource mockAuthDataSource;
  late MockUserRepository mockUserRepository;
  late SignInWithAppleUseCase useCase;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    mockUserRepository = MockUserRepository();
    useCase = SignInWithAppleUseCase(
      authDataSource: mockAuthDataSource,
      userRepository: mockUserRepository,
    );
  });

  group('SignInWithAppleUseCase', () {
    test('should create user with displayName when available', () async {
      const AuthResult authResult = AuthResult(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        provider: AuthProvider.apple,
      );

      when(() => mockAuthDataSource.signInWithApple())
          .thenAnswer((_) async => authResult);
      when(() => mockUserRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute();

      expect(result.username, equals('Test User'));
      expect(result.email, equals('test@example.com'));
      expect(result.avatar, equals('https://example.com/photo.jpg'));

      verify(() => mockAuthDataSource.signInWithApple()).called(1);
      verify(() => mockUserRepository.saveUser(any())).called(1);
    });

    test('should create user with email prefix when displayName is null', () async {
      const AuthResult authResult = AuthResult(
        uid: 'test-uid',
        email: 'testuser@example.com',
        provider: AuthProvider.apple,
      );

      when(() => mockAuthDataSource.signInWithApple())
          .thenAnswer((_) async => authResult);
      when(() => mockUserRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute();

      expect(result.username, equals('testuser'));
      expect(result.email, equals('testuser@example.com'));
      expect(result.avatar, isNull);

      verify(() => mockAuthDataSource.signInWithApple()).called(1);
      verify(() => mockUserRepository.saveUser(any())).called(1);
    });

    test('should create user with default name when displayName and email are null', () async {
      const AuthResult authResult = AuthResult(
        uid: 'test-uid',
        provider: AuthProvider.apple,
      );

      when(() => mockAuthDataSource.signInWithApple())
          .thenAnswer((_) async => authResult);
      when(() => mockUserRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute();

      expect(result.username, equals('Apple User'));
      expect(result.email, isNull);
      expect(result.avatar, isNull);

      verify(() => mockAuthDataSource.signInWithApple()).called(1);
      verify(() => mockUserRepository.saveUser(any())).called(1);
    });

    test('should propagate error from authDataSource', () async {
      when(() => mockAuthDataSource.signInWithApple())
          .thenThrow(Exception('Auth failed'));

      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );

      verify(() => mockAuthDataSource.signInWithApple()).called(1);
      verifyNever(() => mockUserRepository.saveUser(any()));
    });

    test('should propagate error from userRepository', () async {
      const AuthResult authResult = AuthResult(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        provider: AuthProvider.apple,
      );

      when(() => mockAuthDataSource.signInWithApple())
          .thenAnswer((_) async => authResult);
      when(() => mockUserRepository.saveUser(any()))
          .thenThrow(Exception('Save failed'));

      try {
        await useCase.execute();
        fail('Expected exception to be thrown');
      } catch (e) {
        expect(e, isA<Exception>());
      }

      verify(() => mockAuthDataSource.signInWithApple()).called(1);
      verify(() => mockUserRepository.saveUser(any())).called(1);
    });
  });
}

