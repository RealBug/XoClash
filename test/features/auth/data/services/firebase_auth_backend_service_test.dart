import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/auth/data/services/auth_backend_service.dart';
import 'package:tictac/features/auth/data/services/firebase_auth_backend_service.dart';

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class MockUser extends Mock implements firebase_auth.User {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockAuthCredential extends Mock implements firebase_auth.AuthCredential {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockLoggerService mockLogger;
  late FirebaseAuthBackendService service;

  setUpAll(() {
    registerFallbackValue(MockAuthCredential());
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockLogger = MockLoggerService();

    when(() => mockLogger.info(any())).thenReturn(null);
    when(() => mockLogger.debug(any())).thenReturn(null);
    when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

    service = FirebaseAuthBackendService(
      mockFirebaseAuth,
      mockGoogleSignIn,
      mockLogger,
    );
  });

  group('signInAnonymously', () {
    test('should return AuthResult with anonymous provider', () async {
      final MockUser mockUser = MockUser();
      final MockUserCredential mockCredential = MockUserCredential();

      when(() => mockUser.uid).thenReturn('anon-uid-123');
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockFirebaseAuth.signInAnonymously())
          .thenAnswer((_) async => mockCredential);

      final AuthResult result = await service.signInAnonymously();

      expect(result.uid, 'anon-uid-123');
      expect(result.provider, AuthProvider.anonymous);
      expect(result.email, isNull);
      verify(() => mockFirebaseAuth.signInAnonymously()).called(1);
    });

    test('should throw exception when user is null', () async {
      final MockUserCredential mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(null);
      when(() => mockFirebaseAuth.signInAnonymously())
          .thenAnswer((_) async => mockCredential);

      expect(
        () => service.signInAnonymously(),
        throwsA(isA<Exception>()),
      );
    });

    test('should propagate Firebase errors', () async {
      when(() => mockFirebaseAuth.signInAnonymously())
          .thenThrow(Exception('Firebase error'));

      expect(
        () => service.signInAnonymously(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('signInWithGoogle', () {
    test('should return AuthResult with Google provider', () async {
      final MockUser mockUser = MockUser();
      final MockUserCredential mockCredential = MockUserCredential();
      final MockGoogleSignInAccount mockGoogleUser = MockGoogleSignInAccount();
      final MockGoogleSignInAuthentication mockGoogleAuth = MockGoogleSignInAuthentication();

      when(() => mockGoogleUser.authentication)
          .thenReturn(mockGoogleAuth);
      when(() => mockGoogleAuth.idToken).thenReturn('google-id-token');
      when(() => mockGoogleSignIn.authenticate())
          .thenAnswer((_) async => mockGoogleUser);

      when(() => mockUser.uid).thenReturn('google-uid-456');
      when(() => mockUser.email).thenReturn('test@gmail.com');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUser.photoURL).thenReturn('https://photo.jpg');
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockFirebaseAuth.signInWithCredential(any()))
          .thenAnswer((_) async => mockCredential);

      final AuthResult result = await service.signInWithGoogle();

      expect(result.uid, 'google-uid-456');
      expect(result.email, 'test@gmail.com');
      expect(result.displayName, 'Test User');
      expect(result.photoUrl, 'https://photo.jpg');
      expect(result.provider, AuthProvider.google);
      verify(() => mockGoogleSignIn.authenticate()).called(1);
      verify(() => mockFirebaseAuth.signInWithCredential(any())).called(1);
    });

    test('should throw exception when user is null', () async {
      final MockGoogleSignInAccount mockGoogleUser = MockGoogleSignInAccount();
      final MockGoogleSignInAuthentication mockGoogleAuth = MockGoogleSignInAuthentication();
      final MockUserCredential mockCredential = MockUserCredential();

      when(() => mockGoogleUser.authentication).thenReturn(mockGoogleAuth);
      when(() => mockGoogleAuth.idToken).thenReturn('google-id-token');
      when(() => mockGoogleSignIn.authenticate())
          .thenAnswer((_) async => mockGoogleUser);
      when(() => mockCredential.user).thenReturn(null);
      when(() => mockFirebaseAuth.signInWithCredential(any()))
          .thenAnswer((_) async => mockCredential);

      expect(
        () => service.signInWithGoogle(),
        throwsA(isA<Exception>()),
      );
    });

    test('should propagate GoogleSignIn errors', () async {
      when(() => mockGoogleSignIn.authenticate())
          .thenThrow(Exception('Google sign-in cancelled'));

      expect(
        () => service.signInWithGoogle(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('signInWithApple', () {
  });

  group('signInWithEmailPassword', () {
    test('should return AuthResult with emailPassword provider', () async {
      final MockUser mockUser = MockUser();
      final MockUserCredential mockCredential = MockUserCredential();

      when(() => mockUser.uid).thenReturn('email-uid-101');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.displayName).thenReturn('Email User');
      when(() => mockUser.photoURL).thenReturn('https://photo.jpg');
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockCredential);

      final AuthResult result = await service.signInWithEmailPassword(
        'test@example.com',
        'password123',
      );

      expect(result.uid, 'email-uid-101');
      expect(result.email, 'test@example.com');
      expect(result.displayName, 'Email User');
      expect(result.provider, AuthProvider.emailPassword);
      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('should throw exception when user is null', () async {
      final MockUserCredential mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(null);
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCredential);

      expect(
        () => service.signInWithEmailPassword('test@example.com', 'password'),
        throwsA(isA<Exception>()),
      );
    });

    test('should propagate Firebase auth errors', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(firebase_auth.FirebaseAuthException(
        code: 'wrong-password',
        message: 'Invalid password',
      ));

      expect(
        () => service.signInWithEmailPassword('test@example.com', 'wrong'),
        throwsA(isA<Exception>()),
      );
      verify(() => mockLogger.error(
            'Firebase email sign-in failed',
            any(),
            any(),
          )).called(1);
    });
  });

  group('createAccountWithEmailPassword', () {
    test('should return AuthResult with emailPassword provider', () async {
      final MockUser mockUser = MockUser();
      final MockUserCredential mockCredential = MockUserCredential();

      when(() => mockUser.uid).thenReturn('new-uid-202');
      when(() => mockUser.email).thenReturn('new@example.com');
      when(() => mockUser.displayName).thenReturn('New User');
      when(() => mockUser.photoURL).thenReturn('https://photo.jpg');
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockCredential);

      final AuthResult result = await service.createAccountWithEmailPassword(
        'new@example.com',
        'password123',
      );

      expect(result.uid, 'new-uid-202');
      expect(result.email, 'new@example.com');
      expect(result.provider, AuthProvider.emailPassword);
      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password123',
          )).called(1);
    });

    test('should throw exception when user is null', () async {
      final MockUserCredential mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(null);
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCredential);

      expect(
        () => service.createAccountWithEmailPassword('test@example.com', 'pass'),
        throwsA(isA<Exception>()),
      );
    });

    test('should propagate Firebase auth errors', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(firebase_auth.FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'Email already exists',
      ));

      expect(
        () => service.createAccountWithEmailPassword('existing@example.com', 'pass'),
        throwsA(isA<Exception>()),
      );
      verify(() => mockLogger.error(
            'Firebase account creation failed',
            any(),
            any(),
          )).called(1);
    });
  });

  group('signOut', () {
    test('should sign out from Firebase and Google', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async {});

      await service.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
      verify(() => mockGoogleSignIn.signOut()).called(1);
    });

    test('should propagate errors', () async {
      when(() => mockFirebaseAuth.signOut())
          .thenThrow(Exception('Sign-out failed'));

      expect(
        () => service.signOut(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockLogger.error(
            'Firebase sign-out failed',
            any(),
            any(),
          )).called(1);
    });
  });

  group('currentUser', () {
    test('should return AuthUser when user is signed in', () {
      final MockUser mockUser = MockUser();
      when(() => mockUser.uid).thenReturn('current-uid-303');
      when(() => mockUser.email).thenReturn('current@example.com');
      when(() => mockUser.displayName).thenReturn('Current User');
      when(() => mockUser.photoURL).thenReturn('https://photo.jpg');
      when(() => mockUser.isAnonymous).thenReturn(false);
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final AuthUser? user = service.currentUser;

      expect(user, isNotNull);
      expect(user?.uid, 'current-uid-303');
      expect(user?.email, 'current@example.com');
      expect(user?.displayName, 'Current User');
      expect(user?.isAnonymous, false);
    });

    test('should return null when no user is signed in', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final AuthUser? user = service.currentUser;

      expect(user, isNull);
    });

    test('should handle anonymous user', () {
      final MockUser mockUser = MockUser();
      when(() => mockUser.uid).thenReturn('anon-uid');
      when(() => mockUser.email).thenReturn(null);
      when(() => mockUser.displayName).thenReturn(null);
      when(() => mockUser.photoURL).thenReturn(null);
      when(() => mockUser.isAnonymous).thenReturn(true);
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final AuthUser? user = service.currentUser;

      expect(user, isNotNull);
      expect(user?.isAnonymous, true);
    });
  });

  group('authStateChanges', () {
    test('should return stream of AuthUser', () async {
      final MockUser mockUser1 = MockUser();
      final MockUser mockUser2 = MockUser();

      when(() => mockUser1.uid).thenReturn('user-1');
      when(() => mockUser1.email).thenReturn('user1@example.com');
      when(() => mockUser1.displayName).thenReturn('User 1');
      when(() => mockUser1.photoURL).thenReturn(null);
      when(() => mockUser1.isAnonymous).thenReturn(false);

      when(() => mockUser2.uid).thenReturn('user-2');
      when(() => mockUser2.email).thenReturn('user2@example.com');
      when(() => mockUser2.displayName).thenReturn('User 2');
      when(() => mockUser2.photoURL).thenReturn(null);
      when(() => mockUser2.isAnonymous).thenReturn(false);

      final StreamController<firebase_auth.User?> controller = StreamController<firebase_auth.User?>();
      when(() => mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => controller.stream);

      final Stream<AuthUser?> stream = service.authStateChanges();

      expect(stream, emitsInOrder(<dynamic>[isA<AuthUser>(), isA<AuthUser>()]));

      controller.add(mockUser1);
      controller.add(mockUser2);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await controller.close();
    });

    test('should return null in stream when user signs out', () async {
      final StreamController<firebase_auth.User?> controller = StreamController<firebase_auth.User?>();
      when(() => mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => controller.stream);

      final Stream<AuthUser?> stream = service.authStateChanges();

      expect(stream, emits(null));

      controller.add(null);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await controller.close();
    });
  });

  group('deleteAccount', () {
    test('should delete current user account', () async {
      final MockUser mockUser = MockUser();
      when(() => mockUser.uid).thenReturn('user-to-delete');
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.delete()).thenAnswer((_) async {});

      await service.deleteAccount();

      verify(() => mockUser.delete()).called(1);
    });

    test('should throw exception when no user is signed in', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      expect(
        () => service.deleteAccount(),
        throwsA(isA<Exception>()),
      );
    });

    test('should propagate deletion errors', () async {
      final MockUser mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.delete())
          .thenThrow(Exception('Deletion failed'));

      expect(
        () => service.deleteAccount(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockLogger.error(
            'Firebase account deletion failed',
            any(),
            any(),
          )).called(1);
    });
  });

  group('constructor', () {
    test('should use provided FirebaseAuth when provided', () {
      final FirebaseAuthBackendService serviceWithAuth = FirebaseAuthBackendService(
        mockFirebaseAuth,
        mockGoogleSignIn,
        mockLogger,
      );

      expect(serviceWithAuth, isA<FirebaseAuthBackendService>());
    });

    test('should use provided GoogleSignIn when provided', () {
      final FirebaseAuthBackendService serviceWithGoogleSignIn = FirebaseAuthBackendService(
        mockFirebaseAuth,
        mockGoogleSignIn,
        mockLogger,
      );

      expect(serviceWithGoogleSignIn, isA<FirebaseAuthBackendService>());
    });
  });
}
