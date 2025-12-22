import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

/// Use case for creating a user
/// 
/// This use case handles the business logic for creating a user,
/// including trimming username and email fields.
class CreateUserUseCase {

  CreateUserUseCase(this._userRepository);
  final UserRepository _userRepository;

  /// Creates a user with the provided information
  /// 
  /// [username] - The username (will be trimmed)
  /// [email] - Optional email (will be trimmed if provided)
  /// [avatar] - Optional avatar URL
  /// 
  /// Returns the created User entity
  Future<User> execute(String username, {String? email, String? avatar}) async {
    final String trimmedUsername = username.trim();
    final String? trimmedEmail = email?.trim();
    final User user = User(
      username: trimmedUsername,
      email: trimmedEmail,
      avatar: avatar,
    );
    await _userRepository.saveUser(user);
    return user;
  }
}

