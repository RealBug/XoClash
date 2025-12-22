import 'package:injectable/injectable.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/auth/data/services/auth_backend_service.dart';

abstract class AuthDataSource {
  Future<AuthResult> signInAnonymously();
  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> signInWithApple();
  Future<AuthResult> signInWithEmailPassword(String email, String password);
  Future<AuthResult> createAccountWithEmailPassword(
      String email, String password);
  Future<void> signOut();
  AuthUser? get currentUser;
  Stream<AuthUser?> authStateChanges();
  Future<void> deleteAccount();
}

@Injectable(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {

  AuthDataSourceImpl(
    this._backendService,
    this._logger,
  );
  final AuthBackendService _backendService;
  final LoggerService _logger;

  @override
  Future<AuthResult> signInAnonymously() async {
    _logger.info('Auth: Signing in anonymously');
    try {
      final AuthResult result = await _backendService.signInAnonymously();
      _logger.debug('Anonymous sign-in successful');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Anonymous sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    _logger.info('Auth: Signing in with Google');
    try {
      final AuthResult result = await _backendService.signInWithGoogle();
      _logger.debug('Google sign-in successful');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Google sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResult> signInWithApple() async {
    _logger.info('Auth: Signing in with Apple');
    try {
      final AuthResult result = await _backendService.signInWithApple();
      _logger.debug('Apple sign-in successful');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Apple sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResult> signInWithEmailPassword(
      String email, String password) async {
    _logger.info('Auth: Signing in with email/password');
    try {
      final AuthResult result =
          await _backendService.signInWithEmailPassword(email, password);
      _logger.debug('Email sign-in successful');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Email sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResult> createAccountWithEmailPassword(
      String email, String password) async {
    _logger.info('Auth: Creating account with email/password');
    try {
      final AuthResult result =
          await _backendService.createAccountWithEmailPassword(email, password);
      _logger.debug('Account creation successful');
      return result;
    } catch (e, stackTrace) {
      _logger.error('Account creation failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    _logger.info('Auth: Signing out');
    try {
      await _backendService.signOut();
      _logger.debug('Sign-out successful');
    } catch (e, stackTrace) {
      _logger.error('Sign-out failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  AuthUser? get currentUser => _backendService.currentUser;

  @override
  Stream<AuthUser?> authStateChanges() => _backendService.authStateChanges();

  @override
  Future<void> deleteAccount() async {
    _logger.info('Auth: Deleting account');
    try {
      await _backendService.deleteAccount();
      _logger.debug('Account deletion successful');
    } catch (e, stackTrace) {
      _logger.error('Account deletion failed', e, stackTrace);
      rethrow;
    }
  }
}
