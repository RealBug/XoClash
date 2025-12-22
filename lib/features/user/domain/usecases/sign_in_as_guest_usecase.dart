import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

/// Use case for signing in as a guest user
/// 
/// This use case handles the business logic for creating a guest user,
/// including trimming the username and creating the User entity.
class SignInAsGuestUseCase {

  SignInAsGuestUseCase(this._userRepository);
  final UserRepository _userRepository;

  /// Creates a guest user with the provided username and optional avatar
  /// 
  /// [username] - The username for the guest user (will be trimmed)
  /// [avatar] - Optional avatar URL for the guest user
  /// 
  /// Returns the created User entity
  Future<User> execute(String username, {String? avatar}) async {
    final String trimmedUsername = username.trim();
    final User guestUser = User(username: trimmedUsername, avatar: avatar);
    await _userRepository.saveUser(guestUser);
    return guestUser;
  }
}

