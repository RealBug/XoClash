import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/auth/data/datasources/auth_datasource.dart';
import 'package:tictac/features/auth/data/services/auth_backend_service.dart';

class MockAuthBackendService extends Mock implements AuthBackendService {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockAuthBackendService mockBackendService;
  late MockLoggerService mockLogger;
  late AuthDataSourceImpl dataSource;

  const AuthResult testAuthResult = AuthResult(
    uid: 'test-uid-123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
    provider: AuthProvider.google,
  );

  const AuthUser testAuthUser = AuthUser(
    uid: 'test-uid-123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
    isAnonymous: false,
  );

  setUp(() {
    mockBackendService = MockAuthBackendService();
    mockLogger = MockLoggerService();
    dataSource = AuthDataSourceImpl(mockBackendService, mockLogger);
  });

  group('signInAnonymously', () {
    test('should return AuthResult when backend succeeds', () async {
      const AuthResult anonymousResult = AuthResult(
        uid: 'anon-uid-456',
        provider: AuthProvider.anonymous,
      );

      when(() => mockBackendService.signInAnonymously())
          .thenAnswer((_) async => anonymousResult);

      final AuthResult result = await dataSource.signInAnonymously();

      expect(result, anonymousResult);
      expect(result.provider, AuthProvider.anonymous);
      verify(() => mockBackendService.signInAnonymously()).called(1);
    });

    test('should throw exception when backend fails', () async {
      when(() => mockBackendService.signInAnonymously())
          .thenThrow(Exception('Backend error'));

      expect(
        () => dataSource.signInAnonymously(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.signInAnonymously()).called(1);
    });
  });

  group('signInWithGoogle', () {
    test('should return AuthResult when backend succeeds', () async {
      when(() => mockBackendService.signInWithGoogle())
          .thenAnswer((_) async => testAuthResult);

      final AuthResult result = await dataSource.signInWithGoogle();

      expect(result, testAuthResult);
      expect(result.email, 'test@example.com');
      verify(() => mockBackendService.signInWithGoogle()).called(1);
    });

    test('should throw exception when backend fails', () async {
      when(() => mockBackendService.signInWithGoogle())
          .thenThrow(Exception('Google sign-in cancelled'));

      expect(
        () => dataSource.signInWithGoogle(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.signInWithGoogle()).called(1);
    });
  });

  group('signInWithApple', () {
    test('should return AuthResult when backend succeeds', () async {
      const AuthResult appleResult = AuthResult(
        uid: 'apple-uid-789',
        email: 'apple@example.com',
        displayName: 'Apple User',
        provider: AuthProvider.apple,
      );

      when(() => mockBackendService.signInWithApple())
          .thenAnswer((_) async => appleResult);

      final AuthResult result = await dataSource.signInWithApple();

      expect(result, appleResult);
      expect(result.provider, AuthProvider.apple);
      verify(() => mockBackendService.signInWithApple()).called(1);
    });

    test('should throw exception when backend fails', () async {
      when(() => mockBackendService.signInWithApple())
          .thenThrow(Exception('Apple sign-in failed'));

      expect(
        () => dataSource.signInWithApple(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.signInWithApple()).called(1);
    });
  });

  group('signInWithEmailPassword', () {
    test('should return AuthResult when backend succeeds', () async {
      when(() => mockBackendService.signInWithEmailPassword(
            'test@example.com',
            'password123',
          )).thenAnswer((_) async => testAuthResult);

      final AuthResult result = await dataSource.signInWithEmailPassword(
        'test@example.com',
        'password123',
      );

      expect(result, testAuthResult);
      verify(() => mockBackendService.signInWithEmailPassword(
            'test@example.com',
            'password123',
          )).called(1);
    });

    test('should throw exception when backend fails', () async {
      when(() => mockBackendService.signInWithEmailPassword(
            'test@example.com',
            'wrong-password',
          )).thenThrow(Exception('Invalid credentials'));

      expect(
        () => dataSource.signInWithEmailPassword(
          'test@example.com',
          'wrong-password',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('createAccountWithEmailPassword', () {
    test('should return AuthResult when backend succeeds', () async {
      when(() => mockBackendService.createAccountWithEmailPassword(
            'new@example.com',
            'password123',
          )).thenAnswer((_) async => testAuthResult);

      final AuthResult result = await dataSource.createAccountWithEmailPassword(
        'new@example.com',
        'password123',
      );

      expect(result, testAuthResult);
      verify(() => mockBackendService.createAccountWithEmailPassword(
            'new@example.com',
            'password123',
          )).called(1);
    });

    test('should throw exception when backend fails', () async {
      when(() => mockBackendService.createAccountWithEmailPassword(
            'existing@example.com',
            'password123',
          )).thenThrow(Exception('Email already in use'));

      expect(
        () => dataSource.createAccountWithEmailPassword(
          'existing@example.com',
          'password123',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('signOut', () {
    test('should call backend service signOut', () async {
      when(() => mockBackendService.signOut()).thenAnswer((_) async {});

      await dataSource.signOut();

      verify(() => mockBackendService.signOut()).called(1);
    });

    test('should propagate backend errors', () async {
      when(() => mockBackendService.signOut())
          .thenThrow(Exception('Sign-out failed'));

      expect(
        () => dataSource.signOut(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.signOut()).called(1);
    });
  });

  group('currentUser', () {
    test('should return current user from backend', () {
      when(() => mockBackendService.currentUser).thenReturn(testAuthUser);

      final AuthUser? user = dataSource.currentUser;

      expect(user, testAuthUser);
      expect(user?.uid, 'test-uid-123');
    });

    test('should return null when no user', () {
      when(() => mockBackendService.currentUser).thenReturn(null);

      final AuthUser? user = dataSource.currentUser;

      expect(user, isNull);
    });
  });

  group('authStateChanges', () {
    test('should return stream from backend service', () {
      final Stream<AuthUser?> controller = Stream<AuthUser?>.fromIterable(<AuthUser?>[testAuthUser, null]);
      when(() => mockBackendService.authStateChanges())
          .thenAnswer((_) => controller);

      final Stream<AuthUser?> stream = dataSource.authStateChanges();

      expect(stream, emitsInOrder(<dynamic>[testAuthUser, null]));
    });
  });

  group('deleteAccount', () {
    test('should call backend service deleteAccount', () async {
      when(() => mockBackendService.deleteAccount()).thenAnswer((_) async {});

      await dataSource.deleteAccount();

      verify(() => mockBackendService.deleteAccount()).called(1);
    });

    test('should propagate backend errors', () async {
      when(() => mockBackendService.deleteAccount())
          .thenThrow(Exception('Deletion failed'));

      expect(
        () => dataSource.deleteAccount(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockBackendService.deleteAccount()).called(1);
    });
  });
}
