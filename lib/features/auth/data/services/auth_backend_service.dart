/// Abstract interface for authentication backend operations
///
/// This allows easy replacement of the backend implementation
/// (Firebase Auth, Supabase Auth, custom API, etc.) without affecting the datasource.
abstract class AuthBackendService {
  /// Sign in anonymously and return user ID
  Future<AuthResult> signInAnonymously();

  /// Sign in with Google and return user info
  Future<AuthResult> signInWithGoogle();

  /// Sign in with Apple and return user info
  Future<AuthResult> signInWithApple();

  /// Sign in with email and password
  Future<AuthResult> signInWithEmailPassword(String email, String password);

  /// Create account with email and password
  Future<AuthResult> createAccountWithEmailPassword(
      String email, String password);

  /// Sign out from all providers
  Future<void> signOut();

  /// Get current authenticated user
  AuthUser? get currentUser;

  /// Stream of authentication state changes
  Stream<AuthUser?> authStateChanges();

  /// Delete current user account
  Future<void> deleteAccount();
}

/// Authentication result containing user info
class AuthResult {

  const AuthResult({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.provider,
  });
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final AuthProvider provider;
}

/// Current authenticated user
class AuthUser {

  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.isAnonymous,
  });
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;
}

/// Authentication providers
enum AuthProvider {
  anonymous,
  google,
  apple,
  emailPassword,
}
