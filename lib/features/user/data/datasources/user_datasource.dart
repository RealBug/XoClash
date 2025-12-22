import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/features/user/domain/entities/user.dart';

abstract class UserDataSource {
  Future<User?> getUser();
  Future<void> saveUser(User user);
  Future<bool> hasUser();
  Future<void> deleteUser();
}

@Injectable(as: UserDataSource)
class UserDataSourceImpl implements UserDataSource {
  static const String _usernameKey = AppConstants.storageKeyUsername;
  static const String _emailKey = AppConstants.storageKeyEmail;
  static const String _avatarKey = AppConstants.storageKeyAvatar;

  @override
  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString(_usernameKey);
    if (username == null || username.isEmpty) {
      return null;
    }
    final String? email = prefs.getString(_emailKey);
    final String? avatar = prefs.getString(_avatarKey);
    return User(username: username, email: email, avatar: avatar);
  }

  @override
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, user.username);
    if (user.email != null) {
      await prefs.setString(_emailKey, user.email!);
    } else {
      await prefs.remove(_emailKey);
    }
    if (user.avatar != null) {
      await prefs.setString(_avatarKey, user.avatar!);
    } else {
      await prefs.remove(_avatarKey);
    }
  }

  @override
  Future<bool> hasUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_usernameKey) &&
        (prefs.getString(_usernameKey)?.isNotEmpty ?? false);
  }

  @override
  Future<void> deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_avatarKey);
  }
}

