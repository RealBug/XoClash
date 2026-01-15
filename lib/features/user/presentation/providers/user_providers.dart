import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/errors/error_handler.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/features/settings/domain/usecases/update_avatar_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/update_username_usecase.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/usecases/create_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/delete_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/get_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/has_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/sign_in_as_guest_usecase.dart';
import 'package:tictac/features/user/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:tictac/features/user/domain/usecases/sign_in_with_google_usecase.dart';

final Provider<GetUserUseCase> getUserUseCaseProvider = Provider<GetUserUseCase>((Ref ref) => GetUserUseCase(ref.watch(userRepositoryProvider)));

final Provider<HasUserUseCase> hasUserUseCaseProvider = Provider<HasUserUseCase>((Ref ref) => HasUserUseCase(ref.watch(userRepositoryProvider)));

final Provider<DeleteUserUseCase> deleteUserUseCaseProvider = Provider<DeleteUserUseCase>((Ref ref) => DeleteUserUseCase(ref.watch(userRepositoryProvider)));

final Provider<SignInWithGoogleUseCase> signInWithGoogleUseCaseProvider = Provider<SignInWithGoogleUseCase>(
  (Ref ref) => SignInWithGoogleUseCase(authDataSource: ref.watch(authDataSourceProvider), userRepository: ref.watch(userRepositoryProvider)),
);

final Provider<SignInWithAppleUseCase> signInWithAppleUseCaseProvider = Provider<SignInWithAppleUseCase>(
  (Ref ref) => SignInWithAppleUseCase(authDataSource: ref.watch(authDataSourceProvider), userRepository: ref.watch(userRepositoryProvider)),
);

final Provider<SignInAsGuestUseCase> signInAsGuestUseCaseProvider = Provider<SignInAsGuestUseCase>((Ref ref) => SignInAsGuestUseCase(ref.watch(userRepositoryProvider)));

final Provider<CreateUserUseCase> createUserUseCaseProvider = Provider<CreateUserUseCase>((Ref ref) => CreateUserUseCase(ref.watch(userRepositoryProvider)));

final Provider<UpdateUsernameUseCase> updateUsernameUseCaseProvider = Provider<UpdateUsernameUseCase>((Ref ref) => UpdateUsernameUseCase(ref.watch(userRepositoryProvider)));

final Provider<UpdateAvatarUseCase> updateAvatarUseCaseProvider = Provider<UpdateAvatarUseCase>((Ref ref) => UpdateAvatarUseCase(ref.watch(userRepositoryProvider)));

final AsyncNotifierProvider<UserNotifier, User?> userProvider = AsyncNotifierProvider<UserNotifier, User?>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return await _loadUser();
  }

  GetUserUseCase get getUserUseCase => ref.read(getUserUseCaseProvider);
  HasUserUseCase get hasUserUseCase => ref.read(hasUserUseCaseProvider);
  DeleteUserUseCase get deleteUserUseCase => ref.read(deleteUserUseCaseProvider);
  SignInWithGoogleUseCase get signInWithGoogleUseCase => ref.read(signInWithGoogleUseCaseProvider);
  SignInWithAppleUseCase get signInWithAppleUseCase => ref.read(signInWithAppleUseCaseProvider);
  SignInAsGuestUseCase get signInAsGuestUseCase => ref.read(signInAsGuestUseCaseProvider);
  CreateUserUseCase get createUserUseCase => ref.read(createUserUseCaseProvider);
  UpdateUsernameUseCase get updateUsernameUseCase => ref.read(updateUsernameUseCaseProvider);
  UpdateAvatarUseCase get updateAvatarUseCase => ref.read(updateAvatarUseCaseProvider);

  Future<User?> _loadUser() async {
    final logger = ref.read(loggerServiceProvider);
    logger.debug('Loading user from storage');
    try {
      final user = await getUserUseCase.execute();
      if (user != null) {
        logger.info('User loaded: ${user.username}');
      } else {
        logger.debug('No user found in storage');
      }
      return user;
    } catch (e, stackTrace) {
      logger.error('Failed to load user', e, stackTrace);
      rethrow;
    }
  }

  Future<void> saveUser(String username, {String? email, String? avatar}) async {
    final logger = ref.read(loggerServiceProvider);
    final errorHandler = ref.read(errorHandlerProvider);
    logger.info('Saving user: username=$username, email=$email');
    try {
      final user = await createUserUseCase.execute(username, email: email, avatar: avatar);
      state = AsyncData<User>(user);
      logger.debug('User saved successfully: ${user.username}');
    } catch (e, stackTrace) {
      final appException = errorHandler.handleError(e, stackTrace, context: 'Failed to save user');
      state = AsyncError<User>(appException, stackTrace);
      rethrow;
    }
  }

  Future<bool> hasUser() async {
    final logger = ref.read(loggerServiceProvider);
    logger.debug('Checking if user exists');
    return await hasUserUseCase.execute();
  }

  Future<void> deleteUser() async {
    final logger = ref.read(loggerServiceProvider);
    logger.info('Deleting user');
    try {
      await deleteUserUseCase.execute();
      state = const AsyncData<User?>(null);
      logger.debug('User deleted successfully');
    } catch (e, stackTrace) {
      logger.error('Failed to delete user', e, stackTrace);
      state = AsyncError<User?>(e, stackTrace);
      rethrow;
    }
  }

  Future<void> signInAsGuest(String username, {String? avatar}) async {
    final logger = ref.read(loggerServiceProvider);
    logger.info('Signing in as guest: username=$username');
    try {
      final guestUser = await signInAsGuestUseCase.execute(username, avatar: avatar);
      state = AsyncData<User>(guestUser);
      logger.debug('Guest user signed in: ${guestUser.username}');
    } catch (e, stackTrace) {
      logger.error('Failed to sign in as guest', e, stackTrace);
      state = AsyncError<User>(e, stackTrace);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    final logger = ref.read(loggerServiceProvider);
    logger.info('Initiating Google sign in');
    try {
      final user = await signInWithGoogleUseCase.execute();
      state = AsyncData<User>(user);
      logger.info('Google sign in successful: ${user.username}');
    } catch (e, stackTrace) {
      logger.error('Google sign in failed', e, stackTrace);
      state = AsyncError<User>(e, stackTrace);
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    final logger = ref.read(loggerServiceProvider);
    logger.info('Initiating Apple sign in');
    try {
      final user = await signInWithAppleUseCase.execute();
      state = AsyncData<User>(user);
      logger.info('Apple sign in successful: ${user.username}');
    } catch (e, stackTrace) {
      logger.error('Apple sign in failed', e, stackTrace);
      state = AsyncError<User>(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateUsername(String newUsername) async {
    final logger = ref.read(loggerServiceProvider);
    final errorHandler = ref.read(errorHandlerProvider);
    logger.info('Updating username: $newUsername');
    try {
      final currentUser = state.value;
      final updatedUser = await updateUsernameUseCase.execute(currentUser, newUsername);
      state = AsyncData<User>(updatedUser);
      logger.debug('Username updated successfully: ${updatedUser.username}');
    } catch (e, stackTrace) {
      final appException = errorHandler.handleError(e, stackTrace, context: 'Failed to update username');
      state = AsyncError<User>(appException, stackTrace);
      rethrow;
    }
  }

  Future<void> updateAvatar(String? newAvatar) async {
    final logger = ref.read(loggerServiceProvider);
    final errorHandler = ref.read(errorHandlerProvider);
    logger.info('Updating avatar');
    try {
      final currentUser = state.value;
      final updatedUser = await updateAvatarUseCase.execute(currentUser, newAvatar);
      state = AsyncData<User>(updatedUser);
      logger.debug('Avatar updated successfully');
    } catch (e, stackTrace) {
      final appException = errorHandler.handleError(e, stackTrace, context: 'Failed to update avatar');
      state = AsyncError<User>(appException, stackTrace);
      rethrow;
    }
  }
}
