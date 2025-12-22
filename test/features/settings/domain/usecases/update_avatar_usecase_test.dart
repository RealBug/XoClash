import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/usecases/update_avatar_usecase.dart';
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

  late UpdateAvatarUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdateAvatarUseCase(mockRepository);
  });

  group('UpdateAvatarUseCase', () {
    test('should update avatar and preserve username and email', () async {
      const User currentUser = User(username: 'username', email: 'user@example.com', avatar: 'oldAvatar');
      const String newAvatar = 'newAvatar';
      const User expectedUser = User(username: 'username', email: 'user@example.com', avatar: 'newAvatar');

      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(currentUser, newAvatar);

      expect(result.username, equals(currentUser.username));
      expect(result.email, equals(currentUser.email));
      expect(result.avatar, equals(newAvatar));
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should set avatar to null when newAvatar is null', () async {
      const User currentUser = User(username: 'username', email: 'user@example.com', avatar: 'oldAvatar');
      const User expectedUser = User(username: 'username', email: 'user@example.com');

      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(currentUser, null);

      expect(result.avatar, isNull);
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should throw exception when current user is null', () async {
      const String newAvatar = 'newAvatar';

      expect(
        () => useCase.execute(null, newAvatar),
        throwsA(isA<Exception>().having((Exception e) => e.toString(), 'message', contains('Cannot update avatar: no current user'))),
      );

      verifyNever(() => mockRepository.saveUser(any()));
    });

    test('should preserve null email when updating avatar', () async {
      const User currentUser = User(username: 'username', avatar: 'oldAvatar');
      const String newAvatar = 'newAvatar';

      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(currentUser, newAvatar);

      expect(result.email, isNull);
      verify(() => mockRepository.saveUser(any(that: predicate<User>((User user) => user.email == null)))).called(1);
    });

    test('should propagate errors from repository', () async {
      const User currentUser = User(username: 'username', avatar: 'oldAvatar');
      const String newAvatar = 'newAvatar';
      final Exception exception = Exception('Repository error');

      when(() => mockRepository.saveUser(any())).thenThrow(exception);

      expect(() => useCase.execute(currentUser, newAvatar), throwsA(exception));
    });
  });
}
