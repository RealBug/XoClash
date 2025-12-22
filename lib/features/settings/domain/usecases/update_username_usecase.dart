import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

/// Use case for updating user username
/// 
/// This use case handles the business logic for updating a user's username,
/// including preserving other user data (email, avatar).
class UpdateUsernameUseCase {

  UpdateUsernameUseCase(this._userRepository);
  final UserRepository _userRepository;

  /// Updates the username while preserving email and avatar
  /// 
  /// [currentUser] - The current user entity
  /// [newUsername] - The new username to set
  /// 
  /// Returns the updated User entity
  Future<User> execute(User? currentUser, String newUsername) async {
    final String trimmedUsername = newUsername.trim();
    
    final User updatedUser = User(
      username: trimmedUsername,
      email: currentUser?.email,
      avatar: currentUser?.avatar,
    );
    
    await _userRepository.saveUser(updatedUser);
    return updatedUser;
  }
}
