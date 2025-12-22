import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/features/user/data/datasources/user_datasource.dart';
import 'package:tictac/features/user/domain/entities/user.dart';

void main() {
  late UserDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dataSource = UserDataSourceImpl();
  });

  group('UserDataSourceImpl', () {
    test('should return null when no user exists', () async {
      final User? result = await dataSource.getUser();

      expect(result, isNull);
    });

    test('should return null when username is empty', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_username', '');

      final User? result = await dataSource.getUser();

      expect(result, isNull);
    });

    test('should save and retrieve user with all properties', () async {
      const User user = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );

      await dataSource.saveUser(user);
      final User? result = await dataSource.getUser();

      expect(result, isNotNull);
      expect(result?.username, user.username);
      expect(result?.email, user.email);
      expect(result?.avatar, user.avatar);
    });

    test('should save and retrieve user without optional properties', () async {
      const User user = User(username: 'testuser');

      await dataSource.saveUser(user);
      final User? result = await dataSource.getUser();

      expect(result, isNotNull);
      expect(result?.username, user.username);
      expect(result?.email, null);
      expect(result?.avatar, null);
    });

    test('should remove email when set to null', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_username', 'testuser');
      await prefs.setString('user_email', 'old@example.com');

      const User user = User(username: 'testuser');
      await dataSource.saveUser(user);

      expect(prefs.getString('user_email'), isNull);
    });

    test('should remove avatar when set to null', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_username', 'testuser');
      await prefs.setString('user_avatar', '😀');

      const User user = User(username: 'testuser');
      await dataSource.saveUser(user);

      expect(prefs.getString('user_avatar'), isNull);
    });

    test('hasUser should return false when no user exists', () async {
      final bool result = await dataSource.hasUser();

      expect(result, false);
    });

    test('hasUser should return false when username is empty', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_username', '');

      final bool result = await dataSource.hasUser();

      expect(result, false);
    });

    test('hasUser should return true when user exists', () async {
      const User user = User(username: 'testuser');
      await dataSource.saveUser(user);

      final bool result = await dataSource.hasUser();

      expect(result, true);
    });

    test('deleteUser should remove all user data', () async {
      const User user = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );
      await dataSource.saveUser(user);

      await dataSource.deleteUser();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_username'), isNull);
      expect(prefs.getString('user_email'), isNull);
      expect(prefs.getString('user_avatar'), isNull);
    });
  });
}
