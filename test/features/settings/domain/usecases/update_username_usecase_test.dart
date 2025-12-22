import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/usecases/update_username_usecase.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void setUpAllFallbacks() {
  registerFallbackValue(const User(username: 'test-user'));
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });

  late UpdateUsernameUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdateUsernameUseCase(mockRepository);
  });

  group('UpdateUsernameUseCase', () {
    test('should update username and preserve email and avatar', () async {
      const User currentUser = User(
        username: 'oldUsername',
        email: 'user@example.com',
        avatar: 'avatar1',
      );
      const String newUsername = 'newUsername';
      const User expectedUser = User(
        username: 'newUsername',
        email: 'user@example.com',
        avatar: 'avatar1',
      );

      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(currentUser, newUsername);

      expect(result.username, equals(newUsername));
      expect(result.email, equals(currentUser.email));
      expect(result.avatar, equals(currentUser.avatar));
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should trim username before saving', () async {
      const User currentUser = User(username: 'oldUsername');
      const String newUsernameWithSpaces = '  newUsername  ';
      const String expectedUsername = 'newUsername';

      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(currentUser, newUsernameWithSpaces);

      expect(result.username, equals(expectedUsername));
      verify(() => mockRepository.saveUser(any(that: predicate<User>((User user) => user.username == expectedUsername)))).called(1);
    });

    test('should handle null current user', () async {
      const String newUsername = 'newUsername';
      const User expectedUser = User(username: 'newUsername');

      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(null, newUsername);

      expect(result.username, equals(newUsername));
      expect(result.email, isNull);
      expect(result.avatar, isNull);
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should preserve null email and avatar when current user is null', () async {
      const String newUsername = 'newUsername';

      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(null, newUsername);

      expect(result.email, isNull);
      expect(result.avatar, isNull);
      verify(() => mockRepository.saveUser(any(that: predicate<User>((User user) => user.email == null && user.avatar == null)))).called(1);
    });

    test('should propagate errors from repository', () async {
      const User currentUser = User(username: 'oldUsername');
      const String newUsername = 'newUsername';
      final Exception exception = Exception('Repository error');

      when(() => mockRepository.saveUser(any())).thenThrow(exception);

      expect(() => useCase.execute(currentUser, newUsername), throwsA(exception));
    });
  });
}

