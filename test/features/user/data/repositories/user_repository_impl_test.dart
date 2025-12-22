import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/user/data/datasources/user_datasource.dart';
import 'package:tictac/features/user/data/repositories/user_repository_impl.dart';
import 'package:tictac/features/user/domain/entities/user.dart';

class MockUserDataSource extends Mock implements UserDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockUserDataSource();
    repository = UserRepositoryImpl(dataSource: mockDataSource);
  });

  group('UserRepositoryImpl', () {
    test('should get user', () async {
      const User user = User(
        username: 'testuser',
        email: 'test@example.com',
        avatar: '😀',
      );

      when(() => mockDataSource.getUser())
          .thenAnswer((_) async => user);

      final User? result = await repository.getUser();

      expect(result, user);
      verify(() => mockDataSource.getUser()).called(1);
    });

    test('should return null when user does not exist', () async {
      when(() => mockDataSource.getUser())
          .thenAnswer((_) async => null);

      final User? result = await repository.getUser();

      expect(result, isNull);
      verify(() => mockDataSource.getUser()).called(1);
    });

    test('should save user', () async {
      const User user = User(username: 'testuser');

      when(() => mockDataSource.saveUser(user))
          .thenAnswer((_) async => <dynamic, dynamic>{});

      await repository.saveUser(user);

      verify(() => mockDataSource.saveUser(user)).called(1);
    });

    test('should check if user exists', () async {
      when(() => mockDataSource.hasUser())
          .thenAnswer((_) async => true);

      final bool result = await repository.hasUser();

      expect(result, true);
      verify(() => mockDataSource.hasUser()).called(1);
    });

    test('should delete user', () async {
      when(() => mockDataSource.deleteUser())
          .thenAnswer((_) async => <dynamic, dynamic>{});

      await repository.deleteUser();

      verify(() => mockDataSource.deleteUser()).called(1);
    });
  });
}


