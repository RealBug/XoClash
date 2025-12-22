import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/auth/data/services/auth_backend_service.dart';

@Injectable(as: AuthBackendService)
class FirebaseAuthBackendService implements AuthBackendService {

  FirebaseAuthBackendService(
    @factoryParam firebase_auth.FirebaseAuth? auth,
    @factoryParam GoogleSignIn? googleSignIn,
    this._logger,
  )   : _authParam = auth,
        _googleSignInParam = googleSignIn;
  final firebase_auth.FirebaseAuth? _authParam;
  final GoogleSignIn? _googleSignInParam;
  final LoggerService _logger;

  late final firebase_auth.FirebaseAuth _auth =
      _authParam ?? _getFirebaseAuthOrThrow();
  late final GoogleSignIn _googleSignIn =
      _googleSignInParam ?? GoogleSignIn.instance;

  firebase_auth.FirebaseAuth _getFirebaseAuthOrThrow() {
    try {
      return firebase_auth.FirebaseAuth.instance;
    } catch (e) {
      _logger.error(
        'Firebase not initialized. Authentication unavailable. '
        'Run "flutterfire configure" to enable auth.',
        e,
      );
      rethrow;
    }
  }

  @override
  Future<AuthResult> signInAnonymously() async {
    _logger.info('Firebase: Signing in anonymously');
    try {
      final firebase_auth.UserCredential credential = await _auth.signInAnonymously();
      final firebase_auth.User? user = credential.user;
      if (user == null) {
        throw Exception('Anonymous sign-in failed: no user returned');
      }

      _logger.debug('Anonymous sign-in successful: ${user.uid}');
      return AuthResult(
        uid: user.uid,
        provider: AuthProvider.anonymous,
      );
    } catch (e, stackTrace) {
      _logger.error('Firebase anonymous sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    _logger.info('Firebase: Signing in with Google');
    try {
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Google sign-in failed: no user returned');
      }

      _logger.debug('Google sign-in successful: ${user.displayName}');
      return AuthResult(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        provider: AuthProvider.google,
      );
    } catch (e, stackTrace) {
      _logger.error('Firebase Google sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResult> signInWithApple() async {
    _logger.info('Firebase: Signing in with Apple');
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthCredential =
          firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oAuthCredential);
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Apple sign-in failed: no user returned');
      }

      final displayName = appleCredential.givenName ??
          user.displayName ??
          user.email?.split('@')[0];

      _logger.debug('Apple sign-in successful: $displayName');
      return AuthResult(
        uid: user.uid,
        email: user.email ?? appleCredential.email,
        displayName: displayName,
        photoUrl: user.photoURL,
        provider: AuthProvider.apple,
      );
    } catch (e, stackTrace) {
      _logger.error('Firebase Apple sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResult> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    _logger.info('Firebase: Signing in with email/password');
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Email sign-in failed: no user returned');
      }

      _logger.debug('Email sign-in successful: ${user.email}');
      return AuthResult(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        provider: AuthProvider.emailPassword,
      );
    } catch (e, stackTrace) {
      _logger.error('Firebase email sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResult> createAccountWithEmailPassword(
    String email,
    String password,
  ) async {
    _logger.info('Firebase: Creating account with email/password');
    try {
      final firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebase_auth.User? user = userCredential.user;
      if (user == null) {
        throw Exception('Account creation failed: no user returned');
      }

      _logger.debug('Account created successfully: ${user.email}');
      return AuthResult(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        provider: AuthProvider.emailPassword,
      );
    } catch (e, stackTrace) {
      _logger.error('Firebase account creation failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    _logger.info('Firebase: Signing out');
    try {
      await Future.wait(<Future<void>>[
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _logger.debug('Sign-out successful');
    } catch (e, stackTrace) {
      _logger.error('Firebase sign-out failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  AuthUser? get currentUser {
    final firebase_auth.User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
    );
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _auth.authStateChanges().map<AuthUser?>((firebase_auth.User? user) {
      if (user == null) {
        return null;
      }

      return AuthUser(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        isAnonymous: user.isAnonymous,
      );
    });
  }

  @override
  Future<void> deleteAccount() async {
    _logger.info('Firebase: Deleting user account');
    try {
      final firebase_auth.User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user to delete');
      }

      await user.delete();
      _logger.debug('Account deleted successfully');
    } catch (e, stackTrace) {
      _logger.error('Firebase account deletion failed', e, stackTrace);
      rethrow;
    }
  }
}
