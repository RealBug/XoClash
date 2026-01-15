import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/usecases/create_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/delete_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/get_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/has_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/sign_in_as_guest_usecase.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';


void setUpAllFallbacks() {
  registerFallbackValue(const User(username: 'fallback'));
}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}


class MockHasUserUseCase extends Mock implements HasUserUseCase {}

class MockDeleteUserUseCase extends Mock implements DeleteUserUseCase {}

class MockCreateUserUseCase extends Mock implements CreateUserUseCase {}

class MockSignInAsGuestUseCase extends Mock implements SignInAsGuestUseCase {}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });
  late MockGetUserUseCase mockGetUserUseCase;
  late MockHasUserUseCase mockHasUserUseCase;
  late MockDeleteUserUseCase mockDeleteUserUseCase;
  late MockCreateUserUseCase mockCreateUserUseCase;
  late MockSignInAsGuestUseCase mockSignInAsGuestUseCase;
  late ProviderContainer container;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockHasUserUseCase = MockHasUserUseCase();
    mockDeleteUserUseCase = MockDeleteUserUseCase();
    mockCreateUserUseCase = MockCreateUserUseCase();
    mockSignInAsGuestUseCase = MockSignInAsGuestUseCase();

    when(() => mockGetUserUseCase.execute()).thenAnswer((_) async => null);

    container = ProviderContainer(
      overrides: [
        getUserUseCaseProvider.overrideWithValue(mockGetUserUseCase),
        hasUserUseCaseProvider.overrideWithValue(mockHasUserUseCase),
        deleteUserUseCaseProvider.overrideWithValue(mockDeleteUserUseCase),
        createUserUseCaseProvider.overrideWithValue(mockCreateUserUseCase),
        signInAsGuestUseCaseProvider.overrideWithValue(mockSignInAsGuestUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  UserNotifier createNotifier() {
    return container.read(userProvider.notifier);
  }

  group('initial state', () {
    test('should load user on initialization', () async {
      const User user = User(username: 'testuser');

      when(() => mockGetUserUseCase.execute()).thenAnswer((_) async => user);

      final UserNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});
      await Future<void>.microtask(() {});

      verify(() => mockGetUserUseCase.execute()).called(1);
      expect(testNotifier.state.value, equals(user));
    });

    test('should have null state when no user exists', () async {
      when(() => mockGetUserUseCase.execute()).thenAnswer((_) async => null);

      final UserNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});

      expect(testNotifier.state.value, isNull);
    });
  });

  group('saveUser', () {
    test('should save user and update state', () async {
      const String username = 'newuser';
      const User createdUser = User(username: username);

      when(
        () => mockCreateUserUseCase.execute(
          username,
          email: any(named: 'email'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => createdUser);

      final UserNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});
      await testNotifier.saveUser(username);

      verify(() => mockCreateUserUseCase.execute(username)).called(1);
      expect(testNotifier.state.value?.username, equals(username));
    });

    test('should trim username', () async {
      const String username = '  testuser  ';
      const User trimmedUser = User(username: 'testuser');

      when(
        () => mockCreateUserUseCase.execute(
          username,
          email: any(named: 'email'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => trimmedUser);

      final UserNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});
      await testNotifier.saveUser(username);

      verify(() => mockCreateUserUseCase.execute(username)).called(1);
      expect(testNotifier.state.value?.username, equals('testuser'));
    });
  });

  group('hasUser', () {
    test('should return true when user exists', () async {
      when(() => mockHasUserUseCase.execute()).thenAnswer((_) async => true);

      final UserNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});
      final bool result = await testNotifier.hasUser();

      expect(result, isTrue);
      verify(() => mockHasUserUseCase.execute()).called(1);
    });

    test('should return false when user does not exist', () async {
      when(() => mockHasUserUseCase.execute()).thenAnswer((_) async => false);

      final UserNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});
      final bool result = await testNotifier.hasUser();

      expect(result, isFalse);
      verify(() => mockHasUserUseCase.execute()).called(1);
    });
  });

  group('deleteUser', () {
    test('should delete user and set state to null', () async {
      final UserNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});
      testNotifier.state = const AsyncData<User>(User(username: 'testuser'));

      when(() => mockDeleteUserUseCase.execute()).thenAnswer((_) async => Future<void>.value());

      await testNotifier.deleteUser();

      verify(() => mockDeleteUserUseCase.execute()).called(1);
      expect(testNotifier.state.value, isNull);
    });
  });

  group('signInAsGuest', () {
    test('should save guest user and update state', () async {
      const String username = 'guest';
      const User guestUser = User(username: username);

      when(() => mockSignInAsGuestUseCase.execute(username, avatar: any<String?>(named: 'avatar'))).thenAnswer((_) async => guestUser);

      final UserNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});
      await testNotifier.signInAsGuest(username);

      verify(() => mockSignInAsGuestUseCase.execute(username)).called(1);
      expect(testNotifier.state.value?.username, equals(username));
    });
  });
}
