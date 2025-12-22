import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/user/domain/entities/user.dart';

void main() {
  group('User', () {
    test('should create User with required properties', () {
      const User user = User(username: 'testuser');

      expect(user.username, 'testuser');
      expect(user.email, null);
      expect(user.avatar, null);
    });

    test('should create User with all properties', () {
      const User user = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );

      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.avatar, '😀');
    });

    test('copyWith should update properties', () {
      const User user = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );

      final User updated = user.copyWith(
        username: 'newuser',
        email: 'new@example.com',
      );

      expect(updated.username, 'newuser');
      expect(updated.email, 'new@example.com');
      expect(updated.avatar, '😀');
    });

    test('copyWith should set optional properties to null', () {
      const User user = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );

      final User updated = user.copyWith(
        email: null,
        avatar: null,
      );

      expect(updated.username, 'testuser');
      expect(updated.email, null);
      expect(updated.avatar, null);
    });

    test('copyWith should keep original values when null', () {
      const User user = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );

      final User updated = user.copyWith();

      expect(updated.username, 'testuser');
      expect(updated.email, 'test@example.com');
      expect(updated.avatar, '😀');
    });

    test('should be equal when properties are equal', () {
      const User user1 = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );

      const User user2 = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );

      expect(user1, user2);
    });
  });
}


