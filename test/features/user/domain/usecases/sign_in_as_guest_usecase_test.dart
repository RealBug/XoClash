import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';
import 'package:tictac/features/user/domain/usecases/sign_in_as_guest_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void setUpAllFallbacks() {
  registerFallbackValue(
    const User(username: 'test-user'),
  );
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });

  late SignInAsGuestUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = SignInAsGuestUseCase(mockRepository);
  });

  group('SignInAsGuestUseCase', () {
    test('should create guest user with trimmed username', () async {
      const String username = '  test-user  ';
      const String expectedUsername = 'test-user';
      const String avatar = 'avatar-url';
      const User expectedUser = User(username: expectedUsername, avatar: avatar);

      when(() => mockRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(username, avatar: avatar);

      expect(result.username, equals(expectedUsername));
      expect(result.avatar, equals(avatar));
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should create guest user without avatar', () async {
      const String username = 'test-user';
      const User expectedUser = User(username: username);

      when(() => mockRepository.saveUser(any()))
          .thenAnswer((_) async => Future<void>.value());

      final User result = await useCase.execute(username);

      expect(result.username, equals(username));
      expect(result.avatar, isNull);
      verify(() => mockRepository.saveUser(expectedUser)).called(1);
    });

    test('should propagate errors from repository', () async {
      const String username = 'test-user';

      when(() => mockRepository.saveUser(any()))
          .thenThrow(Exception('Repository error'));

      expect(() => useCase.execute(username), throwsException);
      verify(() => mockRepository.saveUser(any())).called(1);
    });
  });
}

