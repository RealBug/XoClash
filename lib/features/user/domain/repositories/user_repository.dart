import 'package:tictac/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> getUser();
  Future<void> saveUser(User user);
  Future<bool> hasUser();
  Future<void> deleteUser();
}
