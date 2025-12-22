import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

/// Use case for updating user avatar
/// 
/// This use case handles the business logic for updating a user's avatar,
/// including preserving other user data (username, email).
class UpdateAvatarUseCase {

  UpdateAvatarUseCase(this._userRepository);
  final UserRepository _userRepository;

  /// Updates the avatar while preserving username and email
  /// 
  /// [currentUser] - The current user entity
  /// [newAvatar] - The new avatar to set (can be null)
  /// 
  /// Returns the updated User entity
  Future<User> execute(User? currentUser, String? newAvatar) async {
    if (currentUser == null) {
      throw Exception('Cannot update avatar: no current user');
    }
    
    final User updatedUser = User(
      username: currentUser.username,
      email: currentUser.email,
      avatar: newAvatar,
    );
    
    await _userRepository.saveUser(updatedUser);
    return updatedUser;
  }
}
